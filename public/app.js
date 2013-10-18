function update(i) {
  image = document.getElementById('image_'+i);
  src = 'server_'+i+'.gif?time='+(new Date().getTime());
  image.src = src;
}

function pulse() {
  update(0);
  update(1);
  update(2);
}

setInterval(pulse,200);
