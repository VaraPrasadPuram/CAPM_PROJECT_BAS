const mysrvdemo = function (srv) {
    srv.on('somesrv', (req, res) => {
        return "hello" + req.data.msg;
    })
}

module.exports = mysrvdemo;

