'use strict';
const request = require('request');

module.exports = {
  metadata: () => ({
    name: 'search',
    properties: {
      ordsUrl: { required: true, type: 'string' },
      offset: { required: false, type: 'string' },
      fullname: { required: true, type: 'string' }
    },
    supportedActions: ['next', 'error']
  }),
  invoke: (conversation, done) => {
  
  const { ordsUrl } = conversation.properties();
  var { fullname } = conversation.properties();
  var { offset } = conversation.properties();
    
  console.log(conversation.properties());

    
  /** 
   * By using an npm module called request, the REST call can get executed. Since the API is shaped into a GET call, this is exactly what we're using.
   * For this simple demo we have no authentication in place. 
   * NOTE: there's many different ways to do this and as the necessities grows, so does the code and complexity.
   * Luckily npm has a wide community with many modules that simplifies development, so have a look and see what suits your use-case.
   * 
   * For more packages: 
   * https://www.npmjs.com/
  */
      
  // This is where we format the query used towards the ORDS endpoint. This is based on the employee value we retrieve from ODA.
  if(!offset)
  {
      offset=0; // default
  }
  conversation.logger().info('offset: ' + offset);
      
  var urlQuery = 'fullname/' + fullname + '?offset=' + offset;
      
   conversation.logger().info('url: ' + ordsUrl + urlQuery);
      
  request({
    followAllRedirects: true,
    url: ordsUrl + urlQuery,
    method: "GET",
    headers: {
      'Content-Type': 'application/json'
    }
  }, function (error, response, body){
    if (error) { 
      conversation.logger().info("Error: " + error); 
      conversation.transition('error'); 
    }
    
    var bodyResponse = JSON.parse(body);

    conversation.logger().info("Data received: \n" + JSON.stringify(bodyResponse));

    /**  SDK helper functions:
     * @variable - sets a variable where conversation.variable(variableInOda, dataToSet)
     * @keepTurn - if we do not expect user-input, move to the next state after execution
     * @transition - moves to the next state
     * 
     * More info can be found at https://oracle.github.io/bots-node-sdk/index.html
    */
    conversation.variable("contactArr", bodyResponse.items)
    conversation.keepTurn(true);
    conversation.transition('next');
    done();
    });
  }
};
