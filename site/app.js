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
  url: "./outputs/LTLA_annual_table.json",
  dataType: "json",
  async: false,
  success: function(data) {
    ltla_annual_table_df = data;
   console.log('LTLA annual vaccine table data successfully loaded.')},
  error: function (xhr) {
    alert('LTLA vaccination annual data not loaded - ' + xhr.statusText);
  },
});

$.ajax({
  url: "./outputs/LTLA_quarterly_table.json",
  dataType: "json",
  async: false,
  success: function(data) {
    ltla_quarterly_table_df = data;
   console.log('LTLA annual vaccine table data successfully loaded.')},
  error: function (xhr) {
    alert('LTLA vaccination annual data not loaded - ' + xhr.statusText);
  },
});

$.ajax({
  url: "./outputs/LTLA_annual.json",
  dataType: "json",
  async: false,
  success: function(data) {
    ltla_annual_df = data;
   console.log('LTLA annual vaccine table data successfully loaded.')},
  error: function (xhr) {
    alert('LTLA vaccination annual data not loaded - ' + xhr.statusText);
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


// ! Render LTLA table on load
window.onload = () => {
  loadTable_ltla_12_months(ltla_12_months_df);
  loadTable_ltla_12_months_quarterly(ltla_12_months_quarterly_df);
  loadTable_ltla_24_months(ltla_24_months_df);
  // loadTable_ltla_24_months_quarterly(ltla_24_months_quarterly_df);
  loadTable_ltla_5_years(ltla_5_years_df)
  // loadTable_ltla_5_years_quarterly(ltla_5_years_quarterly_df);
};


// ! Set some parameters
var benchmark_colour = d3
 .scaleOrdinal()
 .domain(['Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'])
 .range([
        '#CC2629',
        '#E7AF27',
        '#3ECC26', 
        '#8E8E8E']);

// ! Set some parameters
var benchmark_class = d3
 .scaleOrdinal()
 .domain(['Low (<90%)', 'Medium (90-95%)', 'High (95%+)', '-'])
 .range(['low_circle', 'medium_circle', 'high_circle', 'no_circle']);


 	var ltla_table_labels = d3
  .scaleOrdinal()
  .domain(['DTaPIPVHibHepB', 'PCV2', 'MenB', 'Rota', 'MMR1', 'PCV Booster', 'Hib/MenC', 'DTaP/IPV/Hib(Hep)', 'MenB Booster', 'MMR2', 'DTaPIPV'])
  .range(['DTaP/IPV/Hib/HepB vaccine*', 'Pneumococcal conjulate vaccine (PCV)', 'Meningococcal group B', 'Rotavirus', 'Measles, mumps, and rubella vaccine dose 1', 'PCV booster', 'Haemophilus influenzae type B and Meningococcal group C booster', '6-in-1 booster (three doses by second birthday)', 'Meningococcal group B booster', 'Measles, mumps, and rubella vaccine dose 1 and 2', 'Diphtheria, Tetanus, Polio, Pertussis booster'])

function gp_marker_style(feature) {
       return {
            fillColor: benchmark_colour(feature.properties.Benchmark),
            color: benchmark_colour(feature.properties.Benchmark),
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

        

        
// ! Tables 
ltla_12_months_df = ltla_annual_table_df.filter(function (d) {
  return d.Age === '12 months' 
});

function loadTable_ltla_12_months(ltla_12_months_df) {
  const tableBody = document.getElementById("table_ltla_12_months_body");
  var dataHTML = "";

  for (let item of ltla_12_months_df) {
  dataHTML += `<tr><td>${ltla_table_labels(item.Item)}</td><td class = cell_ltla>${item['2017/18']}<div class = ${benchmark_class(item['Benchmark2017/18'])}></div></td><td class = cell_ltla>${item['2018/19']}<div class = ${benchmark_class(item['Benchmark2018/19'])}></div></td><td class = cell_ltla>${item['2019/20']}<div class = ${benchmark_class(item['Benchmark2019/20'])}></div></td><td class = cell_ltla>${item['2020/21']}<div class = ${benchmark_class(item['Benchmark2020/21'])}></div></td><td class = cell_ltla>${item['2021/22']}<div class = ${benchmark_class(item['Benchmark2021/22'])}></div></td></tr>`;
  }
  tableBody.innerHTML = dataHTML;
}

ltla_12_months_quarterly_df = ltla_quarterly_table_df.filter(function (d) {
  return d.Age === '12 months' 
});

function loadTable_ltla_12_months_quarterly(ltla_12_months_quarterly_df) {
  const tableBody = document.getElementById("table_ltla_12_months_quarterly_body");
  var dataHTML = "";

  for (let item of ltla_12_months_quarterly_df) {
  dataHTML += `<tr><td>${ltla_table_labels(item.Item)}</td><td class = cell_ltla>${item['2022/23 Q1']}<div class = ${benchmark_class(item['Benchmark2022/23 Q1'])}></div></td><td class = cell_ltla>${item['2022/23 Q2']}<div class = ${benchmark_class(item['Benchmark2022/23 Q2'])}></div></td><td class = cell_ltla>${item['2022/23 Q3']}<div class = ${benchmark_class(item['Benchmark2022/23 Q3'])}></div></td></tr>`;
  }
  tableBody.innerHTML = dataHTML;
}


ltla_24_months_df = ltla_annual_table_df.filter(function (d) {
  return d.Age === '24 months' 
});

function loadTable_ltla_24_months(ltla_24_months_df) {
  const tableBody = document.getElementById("table_ltla_24_months_body");
  var dataHTML = "";

for (let item of ltla_24_months_df) {
  dataHTML += `<tr><td>${ltla_table_labels(item.Item)}</td><td class = cell_ltla>${item['2017/18']}<div class = ${benchmark_class(item['Benchmark2017/18'])}></div></td><td class = cell_ltla>${item['2018/19']}<div class = ${benchmark_class(item['Benchmark2018/19'])}></div></td><td class = cell_ltla>${item['2019/20']}<div class = ${benchmark_class(item['Benchmark2019/20'])}></div></td><td class = cell_ltla>${item['2020/21']}<div class = ${benchmark_class(item['Benchmark2020/21'])}></div></td><td class = cell_ltla>${item['2021/22']}<div class = ${benchmark_class(item['Benchmark2021/22'])}></div></td></tr>`;
  }
  tableBody.innerHTML = dataHTML;
}


// ltla_24_months_quarterly_df = ltla_quarterly_table_df.filter(function (d) {
//   return d.Age === '24 months' 
// });

// function loadTable_ltla_24_months_quarterly(ltla_24_months_quarterly_df) {
//   const tableBody = document.getElementById("table_ltla_24_months_quarterly_body");
//   var dataHTML = "";

//   for (let item of ltla_24_months_quarterly_df) {
//   dataHTML += `<tr><td>${ltla_table_labels(item.Item)}</td><td class = cell_ltla>${item['2022/23 Q1']}<div class = ${benchmark_class(item['Benchmark2022/23 Q1'])}></div></td><td class = cell_ltla>${item['2022/23 Q2']}<div class = ${benchmark_class(item['Benchmark2022/23 Q2'])}></div></td><td class = cell_ltla>${item['2022/23 Q3']}<div class = ${benchmark_class(item['Benchmark2022/23 Q3'])}></div></td></tr>`;
//   }
//   tableBody.innerHTML = dataHTML;
// }

ltla_5_years_df = ltla_annual_table_df.filter(function (d) {
  return d.Age === '5 years' 
});

function loadTable_ltla_5_years(ltla_5_years_df) {
  const tableBody = document.getElementById("table_ltla_5_years_body");
  var dataHTML = "";

  for (let item of ltla_5_years_df) {
  dataHTML += `<tr><td>${ltla_table_labels(item.Item)}</td><td class = cell_ltla>${item['2017/18']}<div class = ${benchmark_class(item['Benchmark2017/18'])}></div></td><td class = cell_ltla>${item['2018/19']}<div class = ${benchmark_class(item['Benchmark2018/19'])}></div></td><td class = cell_ltla>${item['2019/20']}<div class = ${benchmark_class(item['Benchmark2019/20'])}></div></td><td class = cell_ltla>${item['2020/21']}<div class = ${benchmark_class(item['Benchmark2020/21'])}></div></td><td class = cell_ltla>${item['2021/22']}<div class = ${benchmark_class(item['Benchmark2021/22'])}></div></td></tr>`;
  }
  tableBody.innerHTML = dataHTML;
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
         fillColor: benchmark_colour(gp_immunisations_data_12_months_vaccine_1[i]['Benchmark']),
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

    Annual_12_months_vaccine_1_group.addTo(map_12_months)

    gp_immunisations_data_12_months_vaccine_2 = gp_immunisations_data.filter(function (d) {
      return d.Year == '2021/22' &&
              d.Age === '12 months' &&
              d.Item === 'PCV1';
    });
    
    Annual_12_months_vaccine_2_group = L.layerGroup();
    
    // This loops through the Local_GP_location dataframe and plots a marker for every record.
    for (var i = 0; i < gp_immunisations_data_12_months_vaccine_2.length; i++) {
        new L.circleMarker([gp_immunisations_data_12_months_vaccine_2[i]['latitude'], gp_immunisations_data_12_months_vaccine_2[i]['longitude']],{
             radius: 8,
             weight: .75,
             fillColor: benchmark_colour(gp_immunisations_data_12_months_vaccine_2[i]['Benchmark']),
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
      
 
  gp_immunisations_data_12_months_vaccine_3 = gp_immunisations_data.filter(function (d) {
    return d.Year == '2021/22' &&
            d.Age === '12 months' &&
            d.Item === 'MenB';
  });

 Annual_12_months_vaccine_3_group = L.layerGroup();
    
   // This loops through the Local_GP_location dataframe and plots a marker for every record.
   for (var i = 0; i < gp_immunisations_data_12_months_vaccine_3.length; i++) {
            new L.circleMarker([gp_immunisations_data_12_months_vaccine_3[i]['latitude'], gp_immunisations_data_12_months_vaccine_3[i]['longitude']],{
              radius: 8,
              weight: .75,
              fillColor: benchmark_colour(gp_immunisations_data_12_months_vaccine_3[i]['Benchmark']),
              color: '#fff',
              fillOpacity: 1})
              .bindPopup('<Strong>' + 
              gp_immunisations_data_12_months_vaccine_3[i]['ODS_Code'] + 
                  ' ' + 
                  gp_immunisations_data_12_months_vaccine_3[i]['ODS_Name'] + 
                  '</Strong><br><br>The ' +
                  gp_immunisations_data_12_months_vaccine_3[i]['Age'] +
                  ' coverage for the ' +
                  gp_immunisations_data_12_months_vaccine_3[i]['Term'] +  
                  ' in this practice is <Strong>' + 
                  d3.format('.1%')(gp_immunisations_data_12_months_vaccine_3[i]['Proportion']) +
                  ' </Strong> (based on an eligible population of ' +
                  gp_immunisations_data_12_months_vaccine_3[i]['Denominator'] +
                  ' children).<br><br>According to available data, ' + 
                  d3.format(',.0f')(gp_immunisations_data_12_months_vaccine_3[i]['Denominator'] - gp_immunisations_data_12_months_vaccine_3[i]['Numerator']) + 
                  ' person/people were recorded as not receiving this vaccination.' )
                 .addTo(Annual_12_months_vaccine_3_group) // These markers are directly added to the layer group
                };
            
  gp_immunisations_data_12_months_vaccine_4 = gp_immunisations_data.filter(function (d) {
    return d.Year == '2021/22' &&
            d.Age === '12 months' &&
            d.Item === 'Rota';
  });
  
 Annual_12_months_vaccine_4_group = L.layerGroup();
    
   // This loops through the Local_GP_location dataframe and plots a marker for every record.
   for (var i = 0; i < gp_immunisations_data_12_months_vaccine_4.length; i++) {
            new L.circleMarker([gp_immunisations_data_12_months_vaccine_4[i]['latitude'], gp_immunisations_data_12_months_vaccine_4[i]['longitude']],{
              radius: 8,
              weight: .75,
              fillColor: benchmark_colour(gp_immunisations_data_12_months_vaccine_4[i]['Benchmark']),
              color: '#fff',
              fillOpacity: 1})
              .bindPopup('<Strong>' + 
              gp_immunisations_data_12_months_vaccine_4[i]['ODS_Code'] + 
                  ' ' + 
                  gp_immunisations_data_12_months_vaccine_4[i]['ODS_Name'] + 
                  '</Strong><br><br>The ' +
                  gp_immunisations_data_12_months_vaccine_4[i]['Age'] +
                  ' coverage for the ' +
                  gp_immunisations_data_12_months_vaccine_4[i]['Term'] +  
                  ' in this practice is <Strong>' + 
                  d3.format('.1%')(gp_immunisations_data_12_months_vaccine_4[i]['Proportion']) +
                  ' </Strong> (based on an eligible population of ' +
                  gp_immunisations_data_12_months_vaccine_4[i]['Denominator'] +
                  ' children).<br><br>According to available data, ' + 
                  d3.format(',.0f')(gp_immunisations_data_12_months_vaccine_4[i]['Denominator'] - gp_immunisations_data_12_months_vaccine_4[i]['Numerator']) + 
                  ' person/people were recorded as not receiving this vaccination.' )
                 .addTo(Annual_12_months_vaccine_4_group) // These markers are directly added to the layer group
                };
            

      var baseMaps_map_12_months = {
        "Show DTaP/IPV/Hib/HepB (6-in-1) vaccine coverage": Annual_12_months_vaccine_1_group,
        "Show Pneumococcal conjulate vaccine (PCV) coverage": Annual_12_months_vaccine_2_group,
        "Show Meningococcal group B vaccine coverage": Annual_12_months_vaccine_3_group,
        "Show Rotavirus vaccine coverage": Annual_12_months_vaccine_4_group,
        }
        
    L.control
     .layers(baseMaps_map_12_months, null, { collapsed: false, position: 'topright'})
     .addTo(map_12_months);


      // map_12_months.fitBounds(Annual_12_months_vaccine_1_group.getBounds());

      // benchmark targets (red for less than 90%, amber for 90-95%, green for 95+%

        // Categorical legend 
var legend_map_1 = L.control({position: 'bottomright'});
legend_map_1.onAdd = function (map_12_months) {
    var div = L.DomUtil.create('div', 'info legend'),
        grades = ["Low (<90%)","Medium (90-95%)", "High (95%+)"], // Note that you have to print the labels, you cannot use the object deprivation_deciles
        labels = ['Benchmark<br>coverage'];
    // loop through our density intervals and generate a label with a colored square for each interval
    for (var i = 0; i < grades.length; i++) {
        div.innerHTML +=
        labels.push(
            '<i style="background:' + benchmark_colour(grades[i] + 1) + '"></i> ' +
            grades[i] );
    }
    div.innerHTML = labels.join('<br>');
    return div;
};
legend_map_1.addTo(map_12_months);

// ! 24 months maps

// Create a leaflet map (L.map) in the element map_general_health
var map_24_months = L.map("map_24_months_id");
  
// add the background and attribution to the map
L.tileLayer(tileUrl, { attribution })
 .addTo(map_24_months);

ltla_boundary_24 = L.geoJSON(LAD_boundaries.responseJSON, { style: ltla_style }).addTo(map_24_months);

map_24_months.fitBounds(ltla_boundary_24.getBounds());

gp_immunisations_data_24_months_vaccine_1 = gp_immunisations_data.filter(function (d) {
    return d.Year == '2021/22' &&
            d.Age === '24 months' &&
            d.Item === 'DTaP/IPV/Hib(Hep)';
  });

Annual_24_months_vaccine_1_group = L.layerGroup();

// This loops through the Local_GP_location dataframe and plots a marker for every record.
for (var i = 0; i < gp_immunisations_data_24_months_vaccine_1.length; i++) {
    new L.circleMarker([gp_immunisations_data_24_months_vaccine_1[i]['latitude'], gp_immunisations_data_24_months_vaccine_1[i]['longitude']],{
         radius: 8,
         weight: .75,
         fillColor: benchmark_colour(gp_immunisations_data_24_months_vaccine_1[i]['Benchmark']),
         color: '#fff',
         fillOpacity: 1})
        .bindPopup('<Strong>' + 
        gp_immunisations_data_24_months_vaccine_1[i]['ODS_Code'] + 
        ' ' + 
        gp_immunisations_data_24_months_vaccine_1[i]['ODS_Name'] + 
        '</Strong><br><br>The ' +
        gp_immunisations_data_24_months_vaccine_1[i]['Age'] +
        ' coverage for the ' +
        gp_immunisations_data_24_months_vaccine_1[i]['Term'] +  
        ' in this practice is <Strong>' + 
        d3.format('.1%')(gp_immunisations_data_24_months_vaccine_1[i]['Proportion']) +
        ' </Strong> (based on an eligible population of ' +
        gp_immunisations_data_24_months_vaccine_1[i]['Denominator'] +
        ' children).<br><br>According to available data, the number of children <Strong>recorded as not receiving this vaccination</Strong> is ' + 
        d3.format(',.0f')(gp_immunisations_data_24_months_vaccine_1[i]['Denominator'] - gp_immunisations_data_24_months_vaccine_1[i]['Numerator']) + 
        '.' )
       .addTo(Annual_24_months_vaccine_1_group) // These markers are directly added to the layer group
      };

    Annual_24_months_vaccine_1_group.addTo(map_24_months)

    gp_immunisations_data_24_months_vaccine_2 = gp_immunisations_data.filter(function (d) {
      return d.Year == '2021/22' &&
              d.Age === '24 months' &&
              d.Item === 'MMR1';
    });
    
    Annual_24_months_vaccine_2_group = L.layerGroup();
    
    // This loops through the Local_GP_location dataframe and plots a marker for every record.
    for (var i = 0; i < gp_immunisations_data_24_months_vaccine_2.length; i++) {
        new L.circleMarker([gp_immunisations_data_24_months_vaccine_2[i]['latitude'], gp_immunisations_data_24_months_vaccine_2[i]['longitude']],{
             radius: 8,
             weight: .75,
             fillColor: benchmark_colour(gp_immunisations_data_24_months_vaccine_2[i]['Benchmark']),
             color: '#fff',
             fillOpacity: 1})
            .bindPopup('<Strong>' + 
            gp_immunisations_data_24_months_vaccine_2[i]['ODS_Code'] + 
            ' ' + 
            gp_immunisations_data_24_months_vaccine_2[i]['ODS_Name'] + 
            '</Strong><br><br>The ' +
            gp_immunisations_data_24_months_vaccine_2[i]['Age'] +
            ' coverage for the ' +
            gp_immunisations_data_24_months_vaccine_2[i]['Term'] +  
            ' in this practice is <Strong>' + 
            d3.format('.1%')(gp_immunisations_data_24_months_vaccine_2[i]['Proportion']) +
            ' </Strong> (based on an eligible population of ' +
            gp_immunisations_data_24_months_vaccine_2[i]['Denominator'] +
            ' children).<br><br>According to available data, the number of children <Strong>recorded as not receiving this vaccination</Strong> is ' + 
            d3.format(',.0f')(gp_immunisations_data_24_months_vaccine_2[i]['Denominator'] - gp_immunisations_data_24_months_vaccine_2[i]['Numerator']) + 
            '.' )
           .addTo(Annual_24_months_vaccine_2_group) // These markers are directly added to the layer group
          };
      
 
  gp_immunisations_data_24_months_vaccine_3 = gp_immunisations_data.filter(function (d) {
    return d.Year == '2021/22' &&
            d.Age === '24 months' &&
            d.Item === 'PCV Booster';
  });

Annual_24_months_vaccine_3_group = L.layerGroup();

// This loops through the Local_GP_location dataframe and plots a marker for every record.
for (var i = 0; i < gp_immunisations_data_24_months_vaccine_3.length; i++) {
    new L.circleMarker([gp_immunisations_data_24_months_vaccine_3[i]['latitude'], gp_immunisations_data_24_months_vaccine_3[i]['longitude']],{
      radius: 8,
      weight: .75,
      fillColor: benchmark_colour(gp_immunisations_data_24_months_vaccine_3[i]['Benchmark']),
      color: '#fff',
      fillOpacity: 1})
      .bindPopup('<Strong>' + 
      gp_immunisations_data_24_months_vaccine_3[i]['ODS_Code'] + 
      ' ' + 
      gp_immunisations_data_24_months_vaccine_3[i]['ODS_Name'] + 
      '</Strong><br><br>The ' +
      gp_immunisations_data_24_months_vaccine_3[i]['Age'] +
      ' coverage for the ' +
      gp_immunisations_data_24_months_vaccine_3[i]['Term'] +  
      ' in this practice is <Strong>' + 
      d3.format('.1%')(gp_immunisations_data_24_months_vaccine_3[i]['Proportion']) +
      ' </Strong> (based on an eligible population of ' +
      gp_immunisations_data_24_months_vaccine_3[i]['Denominator'] +
      ' children).<br><br>According to available data, ' + 
      d3.format(',.0f')(gp_immunisations_data_24_months_vaccine_3[i]['Denominator'] - gp_immunisations_data_24_months_vaccine_3[i]['Numerator']) + 
      ' person/people were recorded as not receiving this vaccination.' )
      .addTo(Annual_24_months_vaccine_3_group) // These markers are directly added to the layer group
    };
        
  gp_immunisations_data_24_months_vaccine_4 = gp_immunisations_data.filter(function (d) {
    return d.Year == '2021/22' &&
            d.Age === '24 months' &&
            d.Item === 'Hib/MenC';
  });
  
 Annual_24_months_vaccine_4_group = L.layerGroup();
    
// This loops through the Local_GP_location dataframe and plots a marker for every record.
for (var i = 0; i < gp_immunisations_data_24_months_vaccine_4.length; i++) {
    new L.circleMarker([gp_immunisations_data_24_months_vaccine_4[i]['latitude'], gp_immunisations_data_24_months_vaccine_4[i]['longitude']],{
      radius: 8,
      weight: .75,
      fillColor: benchmark_colour(gp_immunisations_data_24_months_vaccine_4[i]['Benchmark']),
      color: '#fff',
      fillOpacity: 1})
      .bindPopup('<Strong>' + 
      gp_immunisations_data_24_months_vaccine_4[i]['ODS_Code'] + 
      ' ' + 
      gp_immunisations_data_24_months_vaccine_4[i]['ODS_Name'] + 
      '</Strong><br><br>The ' +
      gp_immunisations_data_24_months_vaccine_4[i]['Age'] +
      ' coverage for the ' +
      gp_immunisations_data_24_months_vaccine_4[i]['Term'] +  
      ' in this practice is <Strong>' + 
      d3.format('.1%')(gp_immunisations_data_24_months_vaccine_4[i]['Proportion']) +
      ' </Strong> (based on an eligible population of ' +
      gp_immunisations_data_24_months_vaccine_4[i]['Denominator'] +
      ' children).<br><br>According to available data, ' + 
      d3.format(',.0f')(gp_immunisations_data_24_months_vaccine_4[i]['Denominator'] - gp_immunisations_data_24_months_vaccine_4[i]['Numerator']) + 
      ' person/people were recorded as not receiving this vaccination.' )
      .addTo(Annual_24_months_vaccine_4_group) // These markers are directly added to the layer group
    };


    gp_immunisations_data_24_months_vaccine_5 = gp_immunisations_data.filter(function (d) {
      return d.Year == '2021/22' &&
              d.Age === '24 months' &&
              d.Item === 'MenB Booster';
    });
                
Annual_24_months_vaccine_5_group = L.layerGroup();
  
// This loops through the Local_GP_location dataframe and plots a marker for every record.
for (var i = 0; i < gp_immunisations_data_24_months_vaccine_5.length; i++) {
  new L.circleMarker([gp_immunisations_data_24_months_vaccine_5[i]['latitude'], gp_immunisations_data_24_months_vaccine_5[i]['longitude']],{
    radius: 8,
    weight: .75,
    fillColor: benchmark_colour(gp_immunisations_data_24_months_vaccine_5[i]['Benchmark']),
    color: '#fff',
    fillOpacity: 1})
    .bindPopup('<Strong>' + 
    gp_immunisations_data_24_months_vaccine_5[i]['ODS_Code'] + 
    ' ' + 
    gp_immunisations_data_24_months_vaccine_5[i]['ODS_Name'] + 
    '</Strong><br><br>The ' +
    gp_immunisations_data_24_months_vaccine_5[i]['Age'] +
    ' coverage for the ' +
    gp_immunisations_data_24_months_vaccine_5[i]['Term'] +  
    ' in this practice is <Strong>' + 
    d3.format('.1%')(gp_immunisations_data_24_months_vaccine_5[i]['Proportion']) +
    ' </Strong> (based on an eligible population of ' +
    gp_immunisations_data_24_months_vaccine_5[i]['Denominator'] +
    ' children).<br><br>According to available data, ' + 
    d3.format(',.0f')(gp_immunisations_data_24_months_vaccine_5[i]['Denominator'] - gp_immunisations_data_24_months_vaccine_5[i]['Numerator']) + 
    ' person/people were recorded as not receiving this vaccination.' )
    .addTo(Annual_24_months_vaccine_5_group) // These markers are directly added to the layer group
  };
                      
var baseMaps_map_24_months = {
  "Show DTaP/IPV/Hib/HepB (6-in-1) vaccine coverage": Annual_24_months_vaccine_1_group,
  "Show Measles, Mumps, and rubella coverage": Annual_24_months_vaccine_2_group,
  "Show PCV booster coverage": Annual_24_months_vaccine_3_group,
  "Show Haemophilus influenzae type B and Meningococcal group C vaccine coverage": Annual_24_months_vaccine_4_group,
  "Show Meningococcal group B vaccine coverage": Annual_24_months_vaccine_5_group,
  }
  
L.control
.layers(baseMaps_map_24_months, null, { collapsed: false, position: 'topright'})
.addTo(map_24_months);

// map_12_months.fitBounds(Annual_12_months_vaccine_1_group.getBounds());
// benchmark targets (red for less than 90%, amber for 90-95%, green for 95+%
// Categorical legend 

var legend_map_2 = L.control({position: 'bottomright'});
legend_map_2.onAdd = function (map_24_months) {
var div = L.DomUtil.create('div', 'info legend'),
    grades = ["Low (<90%)","Medium (90-95%)", "High (95%+)"], // Note that you have to print the labels, you cannot use the object deprivation_deciles
    labels = ['Benchmark<br>coverage'];
// loop through our density intervals and generate a label with a colored square for each interval
for (var i = 0; i < grades.length; i++) {
    div.innerHTML +=
    labels.push(
        '<i style="background:' + benchmark_colour(grades[i] + 1) + '"></i> ' +
        grades[i] );
}
div.innerHTML = labels.join('<br>');
return div;
};
legend_map_2.addTo(map_24_months);
























});


















// <img src ='${
//       item.icon_path
//     }' class = "icons_yo"></img>