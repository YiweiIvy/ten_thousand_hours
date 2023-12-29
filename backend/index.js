var axios = require('axios');
var data = JSON.stringify({
    "collection": "Item",
    "database": "todo",
    "dataSource": "10000H",
    "projection": {
        "_id": 1
    }
});
            
var config = {
    method: 'post',
    url: 'https://ap-southeast-1.aws.data.mongodb-api.com/app/data-pduso/endpoint/data/v1/action/findOne',
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Request-Headers': '*',
      'api-key': '6Sjv7L0Q4bTsCDlxSnJLjT9HVMUpk83XSXszjzKlEU8y48KgxiNSlaMJFZ6wwjoX',
    },
    data: data
};
            
axios(config)
    .then(function (response) {
        console.log(JSON.stringify(response.data));
    })
    .catch(function (error) {
        console.log(error);
    });
