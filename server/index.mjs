import nanoexpress from 'nanoexpress';
let app = nanoexpress();

let data = []; // {id: number, coordinates: [{lat: float, lng: float},{},{}]},

app.get('/', (req, res) => {
  return res.send({ status: 'ok', data: data });
});

app.post('/update/:id', (req, res) => {
  // require Content-Type application/json
  let id = Number(req.params.id);
  let found = data.find((d) => {
    return d.id === id;
  });
  let { lat, lng } = req.body;
  let now = new Date();
  if (found !== undefined) {
    found.coordinates.push({lat: lat, lng: lng, date: now});
  } else {
    data.push({id: id, coordinates: [{lat: lat, lng: lng, date: now}]});
  }
  return res.send({ status: 'ok' });
});

app.listen(3000);
