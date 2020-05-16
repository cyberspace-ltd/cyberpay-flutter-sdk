import Flutter
import UIKit
import cyberpaysdk

public class SwiftCyberpayflutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cyberpayflutter", binaryMessenger: registrar.messenger())
    let instance = SwiftCyberpayflutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

 
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    guard let args = call.arguments else {
            return result("iOS could not recognize flutter arguments in method: (sendParams)")
    }
            
   let argsMap = args as! NSDictionary
    
    let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController

    if (call.method == "checkout"){
         DispatchQueue.main.async {
       
            let integrationKey: String = argsMap.value(forKey: "integrationKey") as! String
            let amount: Double = argsMap.value(forKey: "amount") as! Double
            let customerEmail: String = argsMap.value(forKey: "customerEmail") as! String
            let liveMode: Bool = argsMap.value(forKey: "liveMode") as! Bool

             CyberpaySdk.shared.initialise(with: integrationKey, mode: liveMode ? .Live : .Debug )
               .setTransaction(forCustomerEmail: customerEmail, amountInKobo: amount)
                   .dropInCheckout(rootController: controller, onSuccess: {res in
                    result(res.reference);
                   }, onError: { (res, error) in
                       print(error)
                      return result(FlutterError(code: "CYBERPAY_ERROR",
                           message: error.localizedDescription,
                           details: nil))
                     
                   }, onValidate: {result in
                    
                   })
         // result("Params received on iOS = \(someInfo1), \(someInfo2)")
         }

       }
       else if (call.method == "checkoutRef") {
         //server reference already exists
         DispatchQueue.main.async {
           let integrationKey: String = argsMap.value(forKey: "integrationKey") as! String
           let reference: String = argsMap.value(forKey: "reference") as! String
           let liveMode: Bool = argsMap.value(forKey: "liveMode") as! Bool

             do {
               try CyberpaySdk.shared.initialise(with: integrationKey, mode: liveMode ? .Live : .Debug)
                   .continueTransactionFromServer(withReference: reference)
                   .serverDropInCheckout(rootController: controller, onSuccess: { (res) in
                      result(res.reference);

                   }, onError: { (res, error) in
                    print(error)
                       result(FlutterError(code: "CYBERPAY_ERROR",
                           message: error.localizedDescription,
                           details: nil))
                      
                   }) { (result) in
                      
               }
              
           } catch  {
              
           }
          
         }
     }
    else {
        result(FlutterMethodNotImplemented)
    }
  }
}
