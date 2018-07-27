let express = require('express');
let app = express();

app.use(express.static("./"));

app.listen(3000, function() {
    console.log("Dapp server start on port: 3000");
});