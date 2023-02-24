// ! Parameters
var width = window.innerWidth * 0.8 - 20;
var height = width * 0.8;
if (width > 900) {
  var width = 900;
  var height = width * .6;
}
var width_margin = width * 0.15;

// ! Load data
$.ajax({
  url: "./outputs/vaccination_terms.json",
  dataType: "json",
  async: false,
  success: function(data) {
    vaccination_terms = data;
   console.log('Vaccination terms successfully loaded.')},
  error: function (xhr) {
    alert('Vaccination terms data not loaded - ' + xhr.statusText);
  },
});

// ! Load data
$.ajax({
    url: "./outputs/GP_immunisations.json",
    dataType: "json",
    async: false,
    success: function(data) {
      gp_immunisations_data = data;
     console.log('GP immunisation data successfully loaded.')},
    error: function (xhr) {
      alert('GP immunisation data not loaded - ' + xhr.statusText);
    },
  });

gp_marker_colour

var gp_marker_colour = d3
 .scaleOrdinal()
 .domain([''])
 .range(["#92a0d6","#74cf3d","#4577ff","#449e00","#e84fcd","#02de71","#f68bff","#63df6b","#8f227f","#508000","#4646a9","#deab00","#0295e8","#c44e00","#02caf9","#ff355c","#01c2a0","#a50c35","#019461","#ff7390","#00afa6","#ff8753","#0063a5","#c5cd5d","#0a5494","#897400","#b2afff","#395c0a","#f7afed","#90d78a","#9b2344","#00796b","#ff836f","#81b6ff","#843f22","#524b85","#dfc47c","#853a4a","#f8b892","#ff91b9"]);

// Specify that this code should run once the PCN_geojson data request is complete
$.when(gp_immunisations_data).done(function () {

// This tile layer is black and white
var tileUrl = "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png";

// Define an attribution statement to go onto our maps
var attribution = '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Contains Ordnance Survey data © Crown copyright and database right 2022';

// Create a leaflet map (L.map) in the element map_general_health
var map_12_months = L.map("map_12_months_id");
  
// add the background and attribution to the map
L.tileLayer(tileUrl, { attribution })
 .addTo(map_12_months);

gp_immunisations_data_12_months_vaccine_1 = gp_immunisations_data.filter(function (d) {
    return d.Year == '2021/22' &&
            d.Age === '12 months' &&
            d.Item === 'DTaPIPVHibHepB';
  });

Annual_12_months_vaccine_1_group = L.layerGroup();

// This loops through the Local_GP_location dataframe and plots a marker for every record.
for (var i = 0; i < gp_immunisations_data_12_months_vaccine_1.length; i++) {
    new L.circleMarker([gp_immunisations_data_12_months_vaccine_1[i]['latitude'], gp_immunisations_data_12_months_vaccine_1[i]['longitude']],{
         radius: 8,
         weight: .75,
         fillColor: gp_marker_colour,
         color: '#fff',
         fillOpacity: 1})
        .bindPopup('<Strong>' + 
        gp_immunisations_data_12_months_vaccine_1[i]['ODS_Code'] + 
        ' ' + 
        // gp_immunisations_data_12_months_vaccine_1[i]['ODS_Name'] + 
        // '</Strong><br><br>This practice is part of the ' + 
        // gp_immunisations_data_12_months_vaccine_1[i]['PCN_Name'] +
        // '. There are <Strong>' + 
        // d3.format(',.0f')(pcn_gp_location_1[i]['Patients']) + 
        'practice.' )
       .addTo(Annual_12_months_vaccine_1_group) // These markers are directly added to the layer group
      };
      
      Annual_12_months_vaccine_1_group.addTo(map_12_months)


      var baseMaps_map_12_months = {
        "Show DTaP/IPV/Hib/HepB (6-in-1) coverage": Annual_12_months_vaccine_1_group,
        }
        
    L.control
     .layers(baseMaps_map_12_months, null, { collapsed: false, position: 'topright'})
     .addTo(map_12_months);

     map_12_months.fitBounds(Annual_12_months_vaccine_1_group.getBounds(), {maxZoom: 13});

       

});