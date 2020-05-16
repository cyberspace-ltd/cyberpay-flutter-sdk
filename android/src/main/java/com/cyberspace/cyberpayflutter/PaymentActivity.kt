package com.cyberspace.cyberpayflutter

import android.app.Activity
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import com.cyberspace.cyberpaysdk.CyberpaySdk
import com.cyberspace.cyberpaysdk.TransactionCallback
import com.cyberspace.cyberpaysdk.enums.Mode
import com.cyberspace.cyberpaysdk.model.Transaction

class PaymentActivity : AppCompatActivity() {

    var transaction: Transaction? = null
    private var integrationKey: String = ""
    private var liveMode: Boolean = false
    private var isTransactionFromServer = false
    private var customerEmail: String = ""
    private var amount = 0.0
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        transaction = Transaction()
        val intent = intent
        if (intent.extras != null) {
            integrationKey = intent.getStringExtra("integrationKey")
            liveMode = intent.getBooleanExtra("mode", false)
            isTransactionFromServer = intent.getBooleanExtra("referenceMode", false)
            customerEmail = intent.getStringExtra("customerEmail")
            amount = intent.getDoubleExtra("amount", 0.0)

            CyberpaySdk.initialiseSdk(integrationKey, if (liveMode) Mode.Live else Mode.Debug)
            CyberpaySdk.merchantLogo = resources.getDrawable(R.drawable.ic_cyberpay_logo)
        }
        if (!isTransactionFromServer) {
            transaction!!.amount = amount
            transaction!!.customerEmail = customerEmail
            CyberpaySdk.checkoutTransaction(this, transaction!!, object : TransactionCallback() {
                override fun onSuccess(transaction: Transaction) {
                    val returnIntent = getIntent()
                    returnIntent.putExtra("success", transaction.reference)
                    setResult(Activity.RESULT_OK, returnIntent)
                    finish()
                }

                override fun onError(transaction: Transaction, throwable: Throwable) {
                    val returnIntent = getIntent()
                    returnIntent.putExtra("error", throwable.message)
                    setResult(Activity.RESULT_OK, returnIntent)
                    finish()
                }

                override fun onValidate(transaction: Transaction) {}
            })
        } else {
            val reference = intent.getStringExtra("reference")
//            transaction!!.reference = UUID.randomUUID().toString()
            transaction!!.reference = reference
            CyberpaySdk.completeCheckoutTransaction(this, transaction!!, object : TransactionCallback() {
                override fun onSuccess(transaction: Transaction) {

                    val returnIntent = getIntent()
                    returnIntent.putExtra("success", transaction.reference)
                    setResult(Activity.RESULT_OK, returnIntent)
                    finish()
                }

                override fun onError(transaction: Transaction, throwable: Throwable) {
                    val returnIntent = getIntent()
                    returnIntent.putExtra("error", throwable.message)
                    setResult(Activity.RESULT_OK, returnIntent)
                    finish()
                }

                override fun onValidate(transaction: Transaction) {}
            })
        }
    }
}
