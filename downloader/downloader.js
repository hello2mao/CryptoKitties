var request = require('request');
var fs = require('fs');

/*
* url 网络文件地址
* filename 文件名
* callback 回调函数
*/
async function downloadFile(uri, filename, callback) {
    var stream = fs.createWriteStream(filename);
    await request(uri).pipe(stream).on('close', callback);
}

var fileUrlBase = 'https://img.cryptokitties.co/0x06012c8cf97bead5deae237070f9587f8e7a266d/';

function sleep(delay) {
    var start = (new Date()).getTime();
    while ((new Date()).getTime() - start < delay) {
        continue;
    }
}

(async () => {
    for (let i = 0; i < 100; i++) {
        await downloadFile(fileUrlBase + i + '.svg', 'images/' + i + '.svg', function () {
            console.log(i + ' 下载完毕');
        });
        sleep(500);
    }
})();
