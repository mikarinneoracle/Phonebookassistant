# Phonebook Chatbot demo

Following my <a href="https://github.com/mikarinneoracle/phonebook/blob/master/README.md">Phonebook ATP ORDS demo</a> I have built a Oracle Digital Assistant Chatbot that uses the Phonebook ORDS to search and list data from the Phonebook database.

### Instructions:

#### Download and install
Download the `Phonebookassistant(1.0).zip`and then using the OCI Console:
- Create Oracle Digital Assistant (ODA) service instance
- Open the ODA service console
- Navigate to the <b>Development/Digital assistant</b> section
- Import the `Phonebookassistant(1.0).zip` assistant

#### Configure Phonebook ATP ORDS to the Phonebook assistant
Navigate to the <b>Development/Skills</b> from the manu and under the <b>Settings/Configuration</b> add a new <b>Custom Parameter</b> named <i>ordsUrl</i> that links the Chatbot Skill to the Phonebook ORDS.

If you created the Phonebook with the OCI Resource Manager esiest way to get value for this is to go to your Phonebook webpage and open the <i>Inspect/Console</i> view from the Browser (with the right -click on the page) and look for the output `API URL`.

After creating the `ordsUrl` custom parameter you should be able to try out the Chatbot under the Phonebook Assistant with the <b>Play</b> -button. For example try typing `hi` or `all` to the Chatbot input box.

### Integrate the Chatbot on your Phonebook webpage

To integrate to chatbot to the Phonebook webpage or any other page copy do the following:
- Create a `Oracle Web` type Channel with a name `webassistant`, for example
- Once created navigate to <b>Users</b> -tab and under the <b>Route To</b> select the <i>Phonebook Assistant</i> and set the <b>Channel Enabled</b> <i>on</i>
- Insert value <i>*</i> to <b>Allowed Domains</b> and set the <b>Client Authentication Enabled</b> <i>off</i>
- Copy the <b>ChannelId</b> for the next step
- Inside the `<head></head>` tags of your page:
```
<script>
        var chatWidgetSettings = {
            URI: 'oda-258e54cc2f3df4cba8beb2a78abddcd0bb-da4.data.digitalassistant.oci.oraclecloud.com',
            channelId: '02baf222-de19-4dcc-bae2-b843e6cce186'
        };
        function initSdk(name) {
            // Default name is Bots
            if (!name) {
                name = 'Bots';
            }
            setTimeout(() => {
                const Bots = new WebSDK(chatWidgetSettings); // Initiate library with configuration
                Bots.connect()                               // Connect to server
                    .then(() => {
                        console.log("Connection Successful");
                    })
                    .catch((reason) => {
                        console.log("Connection failed");
                        console.log(reason);
                    });
                window[name] = Bots;
            });
        }
    </script>
    <script src="web-sdk.js" onload="initSdk('Bots')">
```
- In the code above edit the <b>URI</b> and <b>ChannelId</b> so that URI is your <i>Didital Assistant Service instant URI</i> and ChannelId is the id you copied in the earlier step from <i>the Channel User settings</i>. Chekout the `webchannel-index.html` for a full example (you can use this replace your Phonebook index.html in the object storage to add the Chatbot on the page).