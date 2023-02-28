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
var LAD_boundaries = $.ajax({
  url: "./outputs/west_sussex_ltlas.geojson",
  dataType: "json",
  success: console.log("LTLA boundary data successfully loaded."),
  error: function (xhr) {
    alert(xhr.statusText);
  },
});

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

var gp_marker_colour = d3
 .scaleOrdinal()
 .domain(['Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'])
 .range([
        '#CC2629',
        '#E7AF27',
        '#3ECC26', 
        '#8E8E8E']);

function gp_marker_style(feature) {
       return {
            fillColor: gp_marker_colour(feature.properties.Benchmark),
            color: gp_marker_colour(feature.properties.Benchmark),
            weight: 1,
            fillOpacity: 0.85,
          };
        }        

function ltla_style(feature) {
       return {
        fill: null,
        color: 'purple',
        weight: 1,
        fillOpacity: 0.25
          };
        }

// Specify that this code should run once the PCN_geojson data request is complete
$.when(LAD_boundaries).done(function () {

// This tile layer is black and white
var tileUrl = "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png";

// Define an attribution statement to go onto our maps
var attribution = '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Contains Ordnance Survey data © Crown copyright and database right 2022';

// Create a leaflet map (L.map) in the element map_general_health
var map_12_months = L.map("map_12_months_id");
  
// add the background and attribution to the map
L.tileLayer(tileUrl, { attribution })
 .addTo(map_12_months);

ltla_boundary = L.geoJSON(LAD_boundaries.responseJSON, { style: ltla_style }).addTo(map_12_months);

map_12_months.fitBounds(ltla_boundary.getBounds());

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
         fillColor: gp_marker_colour(gp_immunisations_data_12_months_vaccine_1[i]['Benchmark']),
         color: '#fff',
         fillOpacity: 1})
        .bindPopup('<Strong>' + 
        gp_immunisations_data_12_months_vaccine_1[i]['ODS_Code'] + 
        ' ' + 
        gp_immunisations_data_12_months_vaccine_1[i]['ODS_Name'] + 
        '</Strong><br><br>The ' +
        gp_immunisations_data_12_months_vaccine_1[i]['Age'] +
        ' coverage for the ' +
        gp_immunisations_data_12_months_vaccine_1[i]['Term'] +  
        ' in this practice is <Strong>' + 
        d3.format('.1%')(gp_immunisations_data_12_months_vaccine_1[i]['Proportion']) +
        ' </Strong> (based on an eligible population of ' +
        gp_immunisations_data_12_months_vaccine_1[i]['Denominator'] +
        ' children).<br><br>According to available data, the number of children <Strong>recorded as not receiving this vaccination</Strong> is ' + 
        d3.format(',.0f')(gp_immunisations_data_12_months_vaccine_1[i]['Denominator'] - gp_immunisations_data_12_months_vaccine_1[i]['Numerator']) + 
        '.' )
       .addTo(Annual_12_months_vaccine_1_group) // These markers are directly added to the layer group
      };

      gp_immunisations_data_12_months_vaccine_2 = gp_immunisations_data.filter(function (d) {
        return d.Year == '2021/22' &&
                d.Age === '12 months' &&
                d.Item === 'MenB';
      });

    Annual_12_months_vaccine_1_group.addTo(map_12_months)
    
    Annual_12_months_vaccine_2_group = L.layerGroup();
    
    // This loops through the Local_GP_location dataframe and plots a marker for every record.
    for (var i = 0; i < gp_immunisations_data_12_months_vaccine_2.length; i++) {
        new L.circleMarker([gp_immunisations_data_12_months_vaccine_2[i]['latitude'], gp_immunisations_data_12_months_vaccine_2[i]['longitude']],{
             radius: 8,
             weight: .75,
             fillColor: gp_marker_colour(gp_immunisations_data_12_months_vaccine_2[i]['Benchmark']),
             color: '#fff',
             fillOpacity: 1})
            .bindPopup('<Strong>' + 
            gp_immunisations_data_12_months_vaccine_2[i]['ODS_Code'] + 
            ' ' + 
            gp_immunisations_data_12_months_vaccine_2[i]['ODS_Name'] + 
            '</Strong><br><br>The ' +
            gp_immunisations_data_12_months_vaccine_2[i]['Age'] +
            ' coverage for the ' +
            gp_immunisations_data_12_months_vaccine_2[i]['Term'] +  
            ' in this practice is <Strong>' + 
            d3.format('.1%')(gp_immunisations_data_12_months_vaccine_2[i]['Proportion']) +
            ' </Strong> (based on an eligible population of ' +
            gp_immunisations_data_12_months_vaccine_2[i]['Denominator'] +
            ' children).<br><br>According to available data, the number of children <Strong>recorded as not receiving this vaccination</Strong> is ' + 
            d3.format(',.0f')(gp_immunisations_data_12_months_vaccine_2[i]['Denominator'] - gp_immunisations_data_12_months_vaccine_2[i]['Numerator']) + 
            '.' )
           .addTo(Annual_12_months_vaccine_2_group) // These markers are directly added to the layer group
          };
      
  Annual_12_months_vaccine_3_group = L.layerGroup();
    
  gp_immunisations_data_12_months_vaccine_3 = gp_immunisations_data.filter(function (d) {
    return d.Year == '2021/22' &&
            d.Age === '12 months' &&
            d.Item === 'MenB';
  });


      // This loops through the Local_GP_location dataframe and plots a marker for every record.
     for (var i = 0; i < gp_immunisations_data_12_months_vaccine_2.length; i++) {
              new L.circleMarker([gp_immunisations_data_12_months_vaccine_2[i]['latitude'], gp_immunisations_data_12_months_vaccine_2[i]['longitude']],{
                   radius: 8,
                   weight: .75,
                   fillColor: gp_marker_colour(gp_immunisations_data_12_months_vaccine_2[i]['Benchmark']),
                   color: '#fff',
                   fillOpacity: 1})
                  .bindPopup('<Strong>' + 
                  gp_immunisations_data_12_months_vaccine_2[i]['ODS_Code'] + 
                  ' ' + 
                  gp_immunisations_data_12_months_vaccine_2[i]['ODS_Name'] + 
                  '</Strong><br><br>The ' +
                  gp_immunisations_data_12_months_vaccine_2[i]['Age'] +
                  ' coverage for the ' +
                  gp_immunisations_data_12_months_vaccine_2[i]['Term'] +  
                  ' in this practice is <Strong>' + 
                  d3.format('.1%')(gp_immunisations_data_12_months_vaccine_2[i]['Proportion']) +
                  ' </Strong> (based on an eligible population of ' +
                  gp_immunisations_data_12_months_vaccine_2[i]['Denominator'] +
                  ' children).<br><br>According to available data, ' + 
                  d3.format(',.0f')(gp_immunisations_data_12_months_vaccine_2[i]['Denominator'] - gp_immunisations_data_12_months_vaccine_2[i]['Numerator']) + 
                  ' person/people were recorded as not receiving this vaccination.' )
                 .addTo(Annual_12_months_vaccine_2_group) // These markers are directly added to the layer group
                };
            


      var baseMaps_map_12_months = {
        "Show DTaP/IPV/Hib/HepB (6-in-1) coverage": Annual_12_months_vaccine_1_group,
        "Show Meningococcal group B coverage": Annual_12_months_vaccine_2_group,
        }
        
    L.control
     .layers(baseMaps_map_12_months, null, { collapsed: false, position: 'topright'})
     .addTo(map_12_months);


      // map_12_months.fitBounds(Annual_12_months_vaccine_1_group.getBounds());

});