var mongoose = require('mongoose');
var db = mongoose.createConnection( 'localhost', 'geo');

var schema = mongoose.Schema( { city: 'string', loc: 'array', areaCode: 'string', country: 'string', region: 'string', locId: 'string', metroCode: 'string', postalCode: 'string'} );

var City = db.model( 'City', schema);

//var query = City.findOne( { 'city': 'Barcelona'});
var distance = 7 / 111.2;
console.log( 'Distance %s', distance);
var query = City.find( { 'loc':  { $near: [48.190120, 16.270895], $maxDistance: distance }} ); 
query.exec( function( err, city){
    if (err) return handleError(err);
    console.log( 'Found you %s' , city);
    process.exit(-1);
});
