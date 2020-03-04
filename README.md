# Phonebook Chatbot demo

Following my <a href="https://github.com/mikarinneoracle/phonebook/blob/master/README.md">Phonebook ATP ORDS demo</a> I have built a Oracle Digital Assistant Chatbot that uses the Phonebook ORDS to search and list data from the Phonebook database.

<img src="https://github.com/mikarinneoracle/phonebookassistant/blob/master/screenshot_phonebookassistant.png" width=1600>

## New! Example how to update <i>Dynamic Entity Country</i> via REST

### Instructions for using the REST API for Dynamic Entities:

#### Download and install Phonebook Skill version 1.1
- Clone/download the `Phonebookassistant(1.1).zip` file and then using the ODA service console import and replace the Phonebookassistant `Phonebook Skill 1.0` with the `Phonebook Skill version 1.1`
- Version 1.1 contains a new `dynamic entity COUNTRY` and some new intents using it
- Train the assistant
- Test the assistant by typing `All countries` and `Show countries for FI`, for example

#### Adding a new country `<i>ES</i>` via REST
- The file `value.json` contains the (new) values for `COUNTRY` dynamic entity, including the value `ES` with some synonyms. You can add more countries if you like.
- Modify the included file `update-values.sh` line #4 with the <i>URL of your ODA instance</i>
- Modify the included file `abort.sh` line #4 with the <i>URL of your ODA instance</i>
- Upload your `ssh public key` in `.pem` format to your tenant under `identity/user/API keys`
- Modify the included file `oci-curl` lines #13-#16 to match your <i>tenancy and user values</i>
- Run the following:
```
><b>sh update-values.sh 1</b>
Skill 1: 29FB8257-6DB8-4CD6-9A95-E985FF154D74 PhonebookSkill
Entity 0: F2844D46-2118-4DF0-8026-43777595DEE1 COUNTRY

Patching values for PhonebookSkill COUNTRY entity, request A5AB9530-B39B-4FF4-B6BA-A03BB17DA99D

{"pushRequestId":"A5AB9530-B39B-4FF4-B6BA-A03BB17DA99D","totalDeleted":0,"totalAdded":3,"totalModified":0}
Patching completed

{"createdOn":"2020-03-04T11:54:54.803Z","updatedOn":"2020-03-04T11:54:55.524Z","id":"A5AB9530-B39B-4FF4-B6BA-A03BB17DA99D","status":"TRAINING","statusMessage":"Request Pushed into training, on user request"}

```
- Check the status:
```
><b>sh abort.sh</b>

Total requests 27:
0 7302E78E-5A4F-4426-80BF-ECB9B45F42F5 ABORTED
1 85A511B0-B05A-43DB-AE13-DB43F97A046F ABORTED
2 29897532-EF8C-410B-9BEE-9056CE8B0CB7 ABORTED
3 B28D0467-630D-48D3-A91E-5BCD9F350DEE COMPLETED
4 2F1B6C3A-FD26-4259-B099-3C2A8039085A COMPLETED
5 5466E8D1-6152-47B9-AC9A-565B69051831 COMPLETED
6 CD1D5EF8-C580-4614-91A8-BF8530A3BAEB COMPLETED
7 87EA0EBB-9BAC-4C9F-A021-D755FC074F4A COMPLETED
8 AC0C6CBB-08B7-4BD3-B39E-11FBD539FE91 COMPLETED
9 A5AB9530-B39B-4FF4-B6BA-A03BB17DA99D COMPLETED
```
- `upload-values.sh` can be also used to list the skills and entities when no parameters are supplied command line e.g. `upload-values.sh`
- `abort.sh` can be also used to abort requests by supplying the `request id` as a poarameter from command line e.g. `abort.sh 1`
- Test the assistant with new `COUNTRY` dynamic entity values by typing `All countries`

### Instructions:

#### Download and install
Clone/download the `Phonebookassistant(1.0).zip`and then using the OCI Console:
- Create Oracle Digital Assistant (ODA) service instance
- Open the ODA service console
- Navigate to the <b>Development/Digital assistant</b> section
- Import the `Phonebookassistant(1.0).zip` assistant

#### Configure Phonebook ATP ORDS to the Phonebook assistant
Navigate to the <b>Development/Skills</b> from the menu and under the <b>Settings/Configuration</b> add a new <b>Custom Parameter</b> named <i>ordsUrl</i> that links the Chatbot Skill to the Phonebook ORDS.

If you created the Phonebook ORDS with the OCI Resource Manager the esiest way to get value for this is to go to your Phonebook webpage and open the <i>Inspect/Console</i> view from the Browser (with the right -click on the page) and look for the output `API URL`.

After creating the `ordsUrl` custom parameter you should be able to try out the Chatbot under the Phonebook Assistant with the <b>Play</b> -button. For example try typing `hi` or `all` to the Chatbot input box.

### Integrate the Chatbot on your Phonebook webpage

To integrate to chatbot to the Phonebook webpage or any other page do the following:
- Create a `Oracle Web` type Channel with a name <i>webassistant</i>, for example
- Once created navigate to <b>Users</b> -tab and under the <b>Route To</b> select the <i>Phonebook Assistant</i> and set the <b>Channel Enabled</b> <i>on</i>
- Insert value <i>*</i> to <b>Allowed Domains</b> and set the <b>Client Authentication Enabled</b> <i>off</i>
- Copy the <b>ChannelId</b> for the next step
- Inside the `<head></head>` tags of your Web page:
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
- In the code above edit the <b>URI</b> and <b>ChannelId</b> so that URI is your <i>Didital Assistant Service instant URI</i> and ChannelId is the id you copied in the earlier step from <i>the Channel User</i> settings
- Clone/download and place the `web-sdk.js` along with your Web page

Check out the `webchannel-index.html` for a full example. (You can use this file to replace your Phonebook index.html in the object storage to add the Chatbot on the page. Remeber to add the `web-sdk.js` to the object storage, too.)