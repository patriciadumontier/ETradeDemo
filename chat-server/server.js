// node server.js
const io = require('socket.io')(3000, { path: '/socket.io' });
io.on('connection', socket => {
  console.log('client connected');
  socket.on('message', msg => {
    console.log('got message', msg);
    // echo it back
    io.emit('message', msg);
  });
});
