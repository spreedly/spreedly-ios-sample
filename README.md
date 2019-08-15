# Spreedly iOS Sample App

This is a sample app which utilizes Spreedly's iOS SDK to do full 3DS 2.0 authentication flows. Although this repo is meant primarly for viewing code examples, it is possible to run the app in a simulator and see 3DS 2.0 authentication flows. If you'd like to do that, there are a couple of things you'll need to do before for it to work.

* Get a production Spreedly account
* Update the `Constants.swift` file with a environment key and access secret
* Gateway token created in the environment you set in the bullet point above

_NOTE:_ At the time of writing, the Spreedly iOS SDK only supports Adyen 3DS 2.0 flows. More gateways are actively being added however running the full app in the simulator and seeing authentication challenge windows will only be supported if the gateway token you're using is an Adyen gateway.

Lastly, although this sample app includes direct HTTP requests to Spreedly's API for running transactions, you should instead send your transaction requests from your mobile app to your own backend. It's not secure to store your Spreedly API keys in your application code. However as this sample app is not meant to be submitted to the app store, we've done it here for simplicities sake.



