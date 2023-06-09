// ! Parameters

var width = window.innerWidth * 0.8 - 20;
var margin = {top: 10, right: 50, bottom: 20, left: 30}
var height = 300 - margin.top - margin.bottom;

var flu_figure_width = (width *.5) - margin.left - margin.right
var ts_figure_width = (width *.7) - margin.left - margin.right

var ts_figure_height = window.innerHeight * .4


var areas = ['West Sussex', 'England']
var area_colours = d3
  .scaleOrdinal()
  .domain(areas)
  .range(['#fa8800',
  '#999999'])
       
var circle_size_function = d3
  .scaleOrdinal()
  .domain(areas)
  .range([8, 5])

var benchmark_colour = d3
.scaleOrdinal()
.domain(['Low (<90%)', 'Medium (90-95%)', 'High (95%+)', 'No eligible patients'])
.range([
       '#CC2629',
       '#E7AF27',
       '#3ECC26', 
       '#8E8E8E']);

var benchmark_class = d3
.scaleOrdinal()
.domain(['Low (<90%)', 'Medium (90-95%)', 'High (95%+)', '-'])
.range(['low_circle', 'medium_circle', 'high_circle', 'no_circle']);


var ltla_table_labels = d3
.scaleOrdinal()
.domain(['DTaPIPVHibHepB', 'PCV2', 'MenB', 'Rota', 'MMR1', 'PCV Booster', 'Hib/MenC', 'DTaP/IPV/Hib(Hep)', 'MenB Booster', 'MMR2', 'DTaPIPV'])
.range(['DTaP/IPV/Hib/HepB vaccine*', 'Pneumococcal conjulate vaccine (PCV)', 'Meningococcal group B', 'Rotavirus', 'Measles, mumps, and rubella vaccine dose 1', 'PCV booster', 'Haemophilus influenzae type B and Meningococcal group C booster', '6-in-1 booster (three doses by second birthday)', 'Meningococcal group B booster', 'Measles, mumps, and rubella vaccine dose 1 and 2', 'Diphtheria, Tetanus, Polio, Pertussis booster'])

var significance_colour = d3
.scaleOrdinal()
.domain(['Lower', 'Similar', 'Higher', 'England'])
// .range([
//        '#DB4325',
//        '#E6E1BC',
//        '#57c4ad', 
//        '#8E8E8E']);
       .range([
        '#CC2629',
        '#E7AF27',
        '#3ECC26', 
        '#8E8E8E']);





// ! Load data
// Vaccine terms
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

// Load annual WSx time series data
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

// West Sussex annual tables 2017/18 onwards for 1, 2, and 5 years.
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

// West Sussex quarterly 2022/23 for 1, 2, and 5 years.
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

// Load GP immunisation data for 1, 2, and 5 years.
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

  $.ajax({
    url: "./outputs/school_flu_immunisations.json",
    dataType: "json",
    async: false,
    success: function(data) {
      school_flu_immunisations_df = data;
     console.log('School flu immunisation data successfully loaded.')},
    error: function (xhr) {
      alert('School flu immunisation data not loaded - ' + xhr.statusText);
    },
  });

  $.ajax({
    url: "./outputs/primary_school_flu_immunisations.json",
    dataType: "json",
    async: false,
    success: function(data) {
      primary_school_flu_immunisations_df = data;
     console.log('Primary school flu immunisation data successfully loaded.')},
    error: function (xhr) {
      alert('School flu immunisation data not loaded - ' + xhr.statusText);
    },
  });


// ! Render tables on load
window.onload = () => {
  loadTable_ltla_12_months(ltla_12_months_df);
  loadTable_ltla_12_months_quarterly(ltla_12_months_quarterly_df);
  loadTable_ltla_24_months(ltla_24_months_df);
  loadTable_ltla_24_months_quarterly(ltla_24_months_quarterly_df);
  loadTable_ltla_5_years(ltla_5_years_df)
  loadTable_ltla_5_years_quarterly(ltla_5_years_quarterly_df);
  loadTable_primary_seasonal_flu_uptake(wsx_primary_school_flu_immunisations_df)
  loadTable_ltla_seasonal_flu_uptake(school_flu_immunisations_df);
};

// Load Local authority district tables data
var LAD_boundaries = $.ajax({
  url: "./outputs/west_sussex_ltlas.geojson",
  dataType: "json",
  success: console.log("LTLA boundary data successfully loaded."),
  error: function (xhr) {
    alert(xhr.statusText);
  },
});

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


ltla_24_months_quarterly_df = ltla_quarterly_table_df.filter(function (d) {
  return d.Age === '24 months' 
});

function loadTable_ltla_24_months_quarterly(ltla_24_months_quarterly_df) {
  const tableBody = document.getElementById("table_ltla_24_months_quarterly_body");
  var dataHTML = "";

  for (let item of ltla_24_months_quarterly_df) {
  dataHTML += `<tr><td>${ltla_table_labels(item.Item)}</td><td class = cell_ltla>${item['2022/23 Q1']}<div class = ${benchmark_class(item['Benchmark2022/23 Q1'])}></div></td><td class = cell_ltla>${item['2022/23 Q2']}<div class = ${benchmark_class(item['Benchmark2022/23 Q2'])}></div></td><td class = cell_ltla>${item['2022/23 Q3']}<div class = ${benchmark_class(item['Benchmark2022/23 Q3'])}></div></td></tr>`;
  }
  tableBody.innerHTML = dataHTML;
}

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

ltla_5_years_quarterly_df = ltla_quarterly_table_df.filter(function (d) {
  return d.Age === '5 years' 
});

function loadTable_ltla_5_years_quarterly(ltla_5_years_quarterly_df) {
  const tableBody = document.getElementById("table_ltla_5_years_quarterly_body");
  var dataHTML = "";

  for (let item of ltla_5_years_quarterly_df) {
  dataHTML += `<tr><td>${ltla_table_labels(item.Item)}</td><td class = cell_ltla>${item['2022/23 Q1']}<div class = ${benchmark_class(item['Benchmark2022/23 Q1'])}></div></td><td class = cell_ltla>${item['2022/23 Q2']}<div class = ${benchmark_class(item['Benchmark2022/23 Q2'])}></div></td><td class = cell_ltla>${item['2022/23 Q3']}<div class = ${benchmark_class(item['Benchmark2022/23 Q3'])}></div></td></tr>`;
  }
  tableBody.innerHTML = dataHTML;
}

wsx_primary_school_flu_immunisations_df = primary_school_flu_immunisations_df.filter(function (d) {
  return d.Area === 'West Sussex' 
});

function loadTable_primary_seasonal_flu_uptake(wsx_primary_school_flu_immunisations_df) {
  const tableBody = document.getElementById("table_primary_seasonal_flu_body");
  var dataHTML = "";

  for (let item of wsx_primary_school_flu_immunisations_df) {
  dataHTML += `<tr><td>${item['Year']}</td><td>${d3.format('.1%')(item['Proportion'])}</td><td>${d3.format(',.0f')(item['Numerator'])}</td><td>${d3.format(',.0f')(item['Denominator'])}</td></tr>`;
  }
  tableBody.innerHTML = dataHTML;
}

function loadTable_ltla_seasonal_flu_uptake(school_flu_immunisations_df) {
  const tableBody = document.getElementById("table_ltla_seasonal_flu_body");
  var dataHTML = "";

  for (let item of school_flu_immunisations_df) {
  dataHTML += `<tr><td>${item['Year group']}</td><td>${item['September 2018 to January 2019']}</td><td>${item['September 2019 to January 2020']}</td><td>${item['September 2020 to January 2021']}</td><td>${item['September 2021 to January 2022']}</td><td>${item['September 2022 to January 2023']}</td></tr>`;
  }
  tableBody.innerHTML = dataHTML;
}

// ! Maps

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

// ! 5 year olds map

// Create a leaflet map (L.map) in the element map_general_health
var map_5_years = L.map("map_5_years_id");
  
// add the background and attribution to the map
L.tileLayer(tileUrl, { attribution })
 .addTo(map_5_years);

ltla_boundary_5_years = L.geoJSON(LAD_boundaries.responseJSON, { style: ltla_style }).addTo(map_5_years);

map_5_years.fitBounds(ltla_boundary_5_years.getBounds());

gp_immunisations_data_5_years_vaccine_1 = gp_immunisations_data.filter(function (d) {
  return d.Year == '2021/22' &&
          d.Age === '5 years' &&
          d.Item === 'DTaP/IPV/Hib';
});

Annual_5_years_vaccine_1_group = L.layerGroup();

// This loops through the Local_GP_location dataframe and plots a marker for every record.
for (var i = 0; i < gp_immunisations_data_5_years_vaccine_1.length; i++) {
  new L.circleMarker([gp_immunisations_data_5_years_vaccine_1[i]['latitude'], gp_immunisations_data_5_years_vaccine_1[i]['longitude']],{
       radius: 8,
       weight: .75,
       fillColor: benchmark_colour(gp_immunisations_data_5_years_vaccine_1[i]['Benchmark']),
       color: '#fff',
       fillOpacity: 1})
      .bindPopup('<Strong>' + 
      gp_immunisations_data_5_years_vaccine_1[i]['ODS_Code'] + 
      ' ' + 
      gp_immunisations_data_5_years_vaccine_1[i]['ODS_Name'] + 
      '</Strong><br><br>The ' +
      gp_immunisations_data_5_years_vaccine_1[i]['Age'] +
      ' coverage for the ' +
      gp_immunisations_data_5_years_vaccine_1[i]['Term'] +  
      ' in this practice is <Strong>' + 
      d3.format('.1%')(gp_immunisations_data_5_years_vaccine_1[i]['Proportion']) +
      ' </Strong> (based on an eligible population of ' +
      gp_immunisations_data_5_years_vaccine_1[i]['Denominator'] +
      ' children).<br><br>According to available data, the number of children <Strong>recorded as not receiving this vaccination</Strong> is ' + 
      d3.format(',.0f')(gp_immunisations_data_5_years_vaccine_1[i]['Denominator'] - gp_immunisations_data_5_years_vaccine_1[i]['Numerator']) + 
      '.' )
     .addTo(Annual_5_years_vaccine_1_group) // These markers are directly added to the layer group
    };

  Annual_5_years_vaccine_1_group.addTo(map_5_years)

  gp_immunisations_data_5_years_vaccine_2 = gp_immunisations_data.filter(function (d) {
    return d.Year == '2021/22' &&
            d.Age === '5 years' &&
            d.Item === 'MMR1';
  });
  
  Annual_5_years_vaccine_2_group = L.layerGroup();
  
  // This loops through the Local_GP_location dataframe and plots a marker for every record.
  for (var i = 0; i < gp_immunisations_data_5_years_vaccine_2.length; i++) {
      new L.circleMarker([gp_immunisations_data_5_years_vaccine_2[i]['latitude'], gp_immunisations_data_5_years_vaccine_2[i]['longitude']],{
           radius: 8,
           weight: .75,
           fillColor: benchmark_colour(gp_immunisations_data_5_years_vaccine_2[i]['Benchmark']),
           color: '#fff',
           fillOpacity: 1})
          .bindPopup('<Strong>' + 
          gp_immunisations_data_5_years_vaccine_2[i]['ODS_Code'] + 
          ' ' + 
          gp_immunisations_data_5_years_vaccine_2[i]['ODS_Name'] + 
          '</Strong><br><br>The ' +
          gp_immunisations_data_5_years_vaccine_2[i]['Age'] +
          ' coverage for the ' +
          gp_immunisations_data_5_years_vaccine_2[i]['Term'] +  
          ' in this practice is <Strong>' + 
          d3.format('.1%')(gp_immunisations_data_5_years_vaccine_2[i]['Proportion']) +
          ' </Strong> (based on an eligible population of ' +
          gp_immunisations_data_5_years_vaccine_2[i]['Denominator'] +
          ' children).<br><br>According to available data, the number of children <Strong>recorded as not receiving this vaccination</Strong> is ' + 
          d3.format(',.0f')(gp_immunisations_data_5_years_vaccine_2[i]['Denominator'] - gp_immunisations_data_5_years_vaccine_2[i]['Numerator']) + 
          '.' )
         .addTo(Annual_5_years_vaccine_2_group) // These markers are directly added to the layer group
        };
    
gp_immunisations_data_5_years_vaccine_3 = gp_immunisations_data.filter(function (d) {
  return d.Year == '2021/22' &&
          d.Age === '5 years' &&
          d.Item === 'MMR2';
});

Annual_5_years_vaccine_3_group = L.layerGroup();

// This loops through the Local_GP_location dataframe and plots a marker for every record.
for (var i = 0; i < gp_immunisations_data_5_years_vaccine_3.length; i++) {
  new L.circleMarker([gp_immunisations_data_5_years_vaccine_3[i]['latitude'], gp_immunisations_data_5_years_vaccine_3[i]['longitude']],{
    radius: 8,
    weight: .75,
    fillColor: benchmark_colour(gp_immunisations_data_5_years_vaccine_3[i]['Benchmark']),
    color: '#fff',
    fillOpacity: 1})
    .bindPopup('<Strong>' + 
    gp_immunisations_data_5_years_vaccine_3[i]['ODS_Code'] + 
    ' ' + 
    gp_immunisations_data_5_years_vaccine_3[i]['ODS_Name'] + 
    '</Strong><br><br>The ' +
    gp_immunisations_data_5_years_vaccine_3[i]['Age'] +
    ' coverage for the ' +
    gp_immunisations_data_5_years_vaccine_3[i]['Term'] +  
    ' in this practice is <Strong>' + 
    d3.format('.1%')(gp_immunisations_data_5_years_vaccine_3[i]['Proportion']) +
    ' </Strong> (based on an eligible population of ' +
    gp_immunisations_data_5_years_vaccine_3[i]['Denominator'] +
    ' children).<br><br>According to available data, ' + 
    d3.format(',.0f')(gp_immunisations_data_5_years_vaccine_3[i]['Denominator'] - gp_immunisations_data_5_years_vaccine_3[i]['Numerator']) + 
    ' person/people were recorded as not receiving this vaccination.' )
    .addTo(Annual_5_years_vaccine_3_group) // These markers are directly added to the layer group
  };
      
gp_immunisations_data_5_years_vaccine_4 = gp_immunisations_data.filter(function (d) {
  return d.Year == '2021/22' &&
          d.Age === '5 years' &&
          d.Item === 'DTaPIPV';
});

Annual_5_years_vaccine_4_group = L.layerGroup();
  
// This loops through the Local_GP_location dataframe and plots a marker for every record.
for (var i = 0; i < gp_immunisations_data_5_years_vaccine_4.length; i++) {
  new L.circleMarker([gp_immunisations_data_5_years_vaccine_4[i]['latitude'], gp_immunisations_data_5_years_vaccine_4[i]['longitude']],{
    radius: 8,
    weight: .75,
    fillColor: benchmark_colour(gp_immunisations_data_5_years_vaccine_4[i]['Benchmark']),
    color: '#fff',
    fillOpacity: 1})
    .bindPopup('<Strong>' + 
    gp_immunisations_data_5_years_vaccine_4[i]['ODS_Code'] + 
    ' ' + 
    gp_immunisations_data_5_years_vaccine_4[i]['ODS_Name'] + 
    '</Strong><br><br>The ' +
    gp_immunisations_data_5_years_vaccine_4[i]['Age'] +
    ' coverage for the ' +
    gp_immunisations_data_5_years_vaccine_4[i]['Term'] +  
    ' in this practice is <Strong>' + 
    d3.format('.1%')(gp_immunisations_data_5_years_vaccine_4[i]['Proportion']) +
    ' </Strong> (based on an eligible population of ' +
    gp_immunisations_data_5_years_vaccine_4[i]['Denominator'] +
    ' children).<br><br>According to available data, ' + 
    d3.format(',.0f')(gp_immunisations_data_5_years_vaccine_4[i]['Denominator'] - gp_immunisations_data_5_years_vaccine_4[i]['Numerator']) + 
    ' person/people were recorded as not receiving this vaccination.' )
    .addTo(Annual_5_years_vaccine_4_group) // These markers are directly added to the layer group
  };

 gp_immunisations_data_5_years_vaccine_5 = gp_immunisations_data.filter(function (d) {
    return d.Year == '2021/22' &&
            d.Age === '5 years' &&
            d.Item === 'Hib/MenC';
  });
              
Annual_5_years_vaccine_5_group = L.layerGroup();

// This loops through the Local_GP_location dataframe and plots a marker for every record.
for (var i = 0; i < gp_immunisations_data_5_years_vaccine_5.length; i++) {
new L.circleMarker([gp_immunisations_data_5_years_vaccine_5[i]['latitude'], gp_immunisations_data_5_years_vaccine_5[i]['longitude']],{
  radius: 8,
  weight: .75,
  fillColor: benchmark_colour(gp_immunisations_data_5_years_vaccine_5[i]['Benchmark']),
  color: '#fff',
  fillOpacity: 1})
  .bindPopup('<Strong>' + 
  gp_immunisations_data_5_years_vaccine_5[i]['ODS_Code'] + 
  ' ' + 
  gp_immunisations_data_5_years_vaccine_5[i]['ODS_Name'] + 
  '</Strong><br><br>The ' +
  gp_immunisations_data_5_years_vaccine_5[i]['Age'] +
  ' coverage for the ' +
  gp_immunisations_data_5_years_vaccine_5[i]['Term'] +  
  ' in this practice is <Strong>' + 
  d3.format('.1%')(gp_immunisations_data_5_years_vaccine_5[i]['Proportion']) +
  ' </Strong> (based on an eligible population of ' +
  gp_immunisations_data_5_years_vaccine_5[i]['Denominator'] +
  ' children).<br><br>According to available data, ' + 
  d3.format(',.0f')(gp_immunisations_data_5_years_vaccine_5[i]['Denominator'] - gp_immunisations_data_5_years_vaccine_5[i]['Numerator']) + 
  ' person/people were recorded as not receiving this vaccination.' )
  .addTo(Annual_5_years_vaccine_5_group) // These markers are directly added to the layer group
};
                    
var baseMaps_map_5_years = {
"Show DTaP/IPV/Hib/HepB (6-in-1) vaccine coverage": Annual_5_years_vaccine_1_group,
"Show Measles, Mumps, and Rubella dose 1 coverage": Annual_5_years_vaccine_2_group,
"Show Measles, Mumps, and Rubella dose 1 and 2 coverage": Annual_5_years_vaccine_3_group,
"Show Diphtheria, Tetanus, Polio, and Pertussis<br>(DTaP/IPV) booster vaccine coverage": Annual_5_years_vaccine_4_group,
"Show Haemophilus influenzae type B and<br>Meningococcal group C booster vaccine coverage": Annual_5_years_vaccine_5_group,
}

L.control
.layers(baseMaps_map_5_years, null, { collapsed: false, position: 'topright'})
.addTo(map_5_years);

// map_12_months.fitBounds(Annual_12_months_vaccine_1_group.getBounds());
// benchmark targets (red for less than 90%, amber for 90-95%, green for 95+%
// Categorical legend 

var legend_map_3 = L.control({position: 'bottomright'});
legend_map_3.onAdd = function (map_5_years) {
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
legend_map_3.addTo(map_5_years);

});

// ! Age 12 months time series figure interactive 

var svg_flu_uptake_timeseries_12_months = d3
.select("#vaccine_12_month_uptake_timeseries")
.append("svg")
.attr("width", ts_figure_width + margin.left + margin.right)
.attr("height", ts_figure_height + margin.top + margin.bottom)
.append("g")
.attr("transform", 
      "translate(" + margin.left + "," + margin.top + ")");


var ts_12_m_data = ltla_annual_df.filter(function (d) {
  return d.Age === '12 months' 
});

var vaccine_ts_12m_items = d3
.map(ts_12_m_data, function (d) {
  return d.Description;
})
.keys();

// vaccine_ts_12m_items = ['Pneumococcal conjulate vaccine (PCV)']
// vaccine_ts_12m_items = ['DTaP/IPV/Hib/HepB vaccine*', 'Meningococcal group B', 'Rotavirus']

d3.select("#vaccine_12_month_uptake_timeseries_button")
  .selectAll("myOptions")
  .data(vaccine_ts_12m_items)
  .enter()
  .append("option")
  .text(function (d) {
    return d;
  })
  .attr("value", function (d) {
    return d;
  });

var x_ts_12m = d3
.scalePoint()
.domain(['2017/18', '2018/19', '2019/20', '2020/21', '2021/22'])
.range([margin.left, ts_figure_width]);

var xAxis_ts_12m = svg_flu_uptake_timeseries_12_months
.append("g")
.attr("transform", "translate(0," + (ts_figure_height - margin.bottom - margin.top) + ")")
.call(
d3.axisBottom(x_ts_12m)
);

xAxis_ts_12m
.selectAll("text")
.style("text-anchor", 'middle')
.style("font-size", ".8rem");

var y_ts_12m = d3
.scaleLinear()
.domain([0.8,1])
.range([ts_figure_height - (margin.top + margin.bottom), margin.top])
.nice();

var yAxis_ts_12m = svg_flu_uptake_timeseries_12_months
.append("g")
.attr("transform", "translate(" + margin.left + ",0)")
.call(d3.axisLeft(y_ts_12m).tickFormat(d3.format(".1%")));

yAxis_ts_12m
.selectAll("text")
.style("font-size", ".8rem");

var chosen_12_month_vaccine = d3
.select("#vaccine_12_month_uptake_timeseries_button")
.property("value");

d3.select("#vaccine_12_month_uptake_timeseries_title").html(function (d) {
  return (
    'Figure - ' +
    chosen_12_month_vaccine +
    ' vaccine coverage compared to England; 2017/18 to 2021/22; ' +
    ' West Sussex compared to England; 12 months schedule;'
  );
});

var chosen_ts_12_m_data = ltla_annual_df.filter(function (d) {
  return d.Age === '12 months' &&
  d.Description === chosen_12_month_vaccine
});

// Group the data
var vaccine_ts_12m_areas_group = d3
.nest() 
.key(function (d) {
  return d.Area;
})
.entries(chosen_ts_12_m_data);

// Lines
var lines_ts_12_m = svg_flu_uptake_timeseries_12_months
.selectAll(".line")
.data(vaccine_ts_12m_areas_group)
.enter()
// .transition()
// .duration(1000)
.append("path")
.attr("id", "flu_lines")
.attr("class", "flu_all_lines")
.attr("stroke", function (d) {
  return area_colours(d.key);
})
.attr("d", function (d) {
  return d3
    .line()
    .x(function (d) {
      return x_ts_12m(d.Year);
    })
    .y(function (d) {
      return y_ts_12m(d.Proportion);
    })(d.values);
})
.style("stroke-width", 1)

// points
var dots_ts_12_m = svg_flu_uptake_timeseries_12_months
.selectAll("circles")
.data(chosen_ts_12_m_data)
.enter()
// .transition()
// .duration(1000)
.append("circle")
.attr("cx", function (d) {
  return x_ts_12m(d.Year);
})
.attr("cy", function (d) {
  return y_ts_12m(d.Proportion);
})
.style("fill", function (d) {
  return significance_colour(d.Significance);
})
.attr("r", function (d) {
  return circle_size_function(d.Area);
})
.attr("stroke", function (d) {
  return '#000';
})
// .on("mouseover", hover_seasonsal_flu_vaccine_points)
// .on("mouseout", mouseleave_seasonal_flu_vaccine);

function update_vaccine_12m_ts(){

// Retrieve the selected 12 month vaccine
var chosen_12_month_vaccine = d3
.select("#vaccine_12_month_uptake_timeseries_button")
.property("value");

d3.select("#vaccine_12_month_uptake_timeseries_title").html(function (d) {
  return (
    'Figure - ' +
    chosen_12_month_vaccine +
    ' vaccine coverage compared to England; 2017/18 to 2021/22; ' +
    ' West Sussex compared to England; 12 months schedule;'
  );
});

var chosen_ts_12_m_data = ltla_annual_df.filter(function (d) {
  return d.Age === '12 months' &&
  d.Description === chosen_12_month_vaccine
});

// Group the data
var vaccine_ts_12m_areas_group = d3
.nest() 
.key(function (d) {
  return d.Area;
})
.entries(chosen_ts_12_m_data);

// TODO handle missing data

lines_ts_12_m 
.data(vaccine_ts_12m_areas_group)
// .enter()
.transition()
.duration(1000)
.attr("d", function (d) {
  return d3
    .line()
    .x(function (d) {
      return x_ts_12m(d.Year);
    })
    .y(function (d) {
      return y_ts_12m(d.Proportion);
    })(d.values);
})

// points
dots_ts_12_m
.data(chosen_ts_12_m_data)
// .enter()
.transition()
.duration(1000)
.attr("cx", function (d) {
  return x_ts_12m(d.Year);
})
.attr("cy", function (d) {
  return y_ts_12m(d.Proportion);
})
.style("fill", function (d) {
  return significance_colour(d.Significance);
})
.attr("r", function (d) {
  return circle_size_function(d.Area);
})
// .on("mouseover", hover_seasonsal_flu_vaccine_points)
// .on("mouseout", mouseleave_seasonal_flu_vaccine);

}

update_vaccine_12m_ts()

// Whenever the select value is changed fire the update vaccine_12m_ts function
d3.select("#vaccine_12_month_uptake_timeseries_button").on("change", function (d) {
  var selected_pcr_tested_area = d3
    .select("#vaccine_12_month_uptake_timeseries_button")
    .property("value");
    update_vaccine_12m_ts();
});


// ! Age 24 months time series figure interactive 

var svg_flu_uptake_timeseries_24_months = d3
.select("#vaccine_24_month_uptake_timeseries")
.append("svg")
.attr("width", ts_figure_width + margin.left + margin.right)
.attr("height", ts_figure_height + margin.top + margin.bottom)
.append("g")
.attr("transform", 
      "translate(" + margin.left + "," + margin.top + ")");


var ts_24_m_data = ltla_annual_df.filter(function (d) {
  return d.Age === '24 months' 
});

var vaccine_ts_24m_items = d3
.map(ts_24_m_data, function (d) {
  return d.Description;
})
.keys();

// vaccine_ts_24m_items = ['DTaP/IPV/Hib/HepB vaccine*', 'Meningococcal group B', 'Rotavirus']

d3.select("#vaccine_24_month_uptake_timeseries_button")
  .selectAll("myOptions")
  .data(vaccine_ts_24m_items)
  .enter()
  .append("option")
  .text(function (d) {
    return d;
  })
  .attr("value", function (d) {
    return d;
  });

var x_ts_24m = d3
.scalePoint()
.domain(['2017/18', '2018/19', '2019/20', '2020/21', '2021/22'])
.range([margin.left, ts_figure_width]);

var xAxis_ts_24m = svg_flu_uptake_timeseries_24_months
.append("g")
.attr("transform", "translate(0," + (ts_figure_height - margin.bottom - margin.top) + ")")
.call(
d3.axisBottom(x_ts_24m)
);

xAxis_ts_24m
.selectAll("text")
.style("text-anchor", 'middle')
.style("font-size", ".8rem");

var y_ts_24m = d3
.scaleLinear()
.domain([0.8,1])
.range([ts_figure_height - (margin.top + margin.bottom), margin.top])
.nice();

var yAxis_ts_24m = svg_flu_uptake_timeseries_24_months
.append("g")
.attr("transform", "translate(" + margin.left + ",0)")
.call(d3.axisLeft(y_ts_24m).tickFormat(d3.format(".1%")));

yAxis_ts_24m
.selectAll("text")
.style("font-size", ".8rem");

var chosen_24_month_vaccine = d3
.select("#vaccine_24_month_uptake_timeseries_button")
.property("value");

d3.select("#vaccine_24_month_uptake_timeseries_title").html(function (d) {
  return (
    'Figure - ' +
    chosen_24_month_vaccine +
    ' vaccine coverage compared to England; 2017/18 to 2021/22; ' +
    ' West Sussex compared to England; 24 months schedule;'
  );
});

var chosen_ts_24_m_data = ltla_annual_df.filter(function (d) {
  return d.Age === '24 months' &&
  d.Description === chosen_24_month_vaccine
});

// Group the data
var vaccine_ts_24m_areas_group = d3
.nest() 
.key(function (d) {
  return d.Area;
})
.entries(chosen_ts_24_m_data);

// Lines
var lines_ts_24_m = svg_flu_uptake_timeseries_24_months
.selectAll(".line")
.data(vaccine_ts_24m_areas_group)
.enter()
// .transition()
// .duration(1000)
.append("path")
.attr("id", "flu_lines")
.attr("class", "flu_all_lines")
.attr("stroke", function (d) {
  return area_colours(d.key);
})
.attr("d", function (d) {
  return d3
    .line()
    .x(function (d) {
      return x_ts_24m(d.Year);
    })
    .y(function (d) {
      return y_ts_24m(d.Proportion);
    })(d.values);
})
.style("stroke-width", 1)

// points
var dots_ts_24_m = svg_flu_uptake_timeseries_24_months
.selectAll("circles")
.data(chosen_ts_24_m_data)
.enter()
// .transition()
// .duration(1000)
.append("circle")
.attr("cx", function (d) {
  return x_ts_24m(d.Year);
})
.attr("cy", function (d) {
  return y_ts_24m(d.Proportion);
})
.style("fill", function (d) {
  return significance_colour(d.Significance);
})
.attr("r", function (d) {
  return circle_size_function(d.Area);
})
.attr("stroke", function (d) {
  return '#000';
})
// .on("mouseover", hover_seasonsal_flu_vaccine_points)
// .on("mouseout", mouseleave_seasonal_flu_vaccine);

function update_vaccine_24m_ts(){

// Retrieve the selected 24 month vaccine
var chosen_24_month_vaccine = d3
.select("#vaccine_24_month_uptake_timeseries_button")
.property("value");

d3.select("#vaccine_24_month_uptake_timeseries_title").html(function (d) {
  return (
    'Figure - ' +
    chosen_24_month_vaccine +
    ' vaccine coverage compared to England; 2017/18 to 2021/22; ' +
    ' West Sussex compared to England; 24 months schedule;'
  );
});

var chosen_ts_24_m_data = ltla_annual_df.filter(function (d) {
  return d.Age === '24 months' &&
  d.Description === chosen_24_month_vaccine
});

// Group the data
var vaccine_ts_24m_areas_group = d3
.nest() 
.key(function (d) {
  return d.Area;
})
.entries(chosen_ts_24_m_data);

// TODO handle missing data

lines_ts_24_m 
.data(vaccine_ts_24m_areas_group)
// .enter()
.transition()
.duration(1000)
.attr("d", function (d) {
  return d3
    .line()
    .x(function (d) {
      return x_ts_24m(d.Year);
    })
    .y(function (d) {
      return y_ts_24m(d.Proportion);
    })(d.values);
})

// points
dots_ts_24_m
.data(chosen_ts_24_m_data)
// .enter()
.transition()
.duration(1000)
.attr("cx", function (d) {
  return x_ts_24m(d.Year);
})
.attr("cy", function (d) {
  return y_ts_24m(d.Proportion);
})
.style("fill", function (d) {
  return significance_colour(d.Significance);
})
.attr("r", function (d) {
  return circle_size_function(d.Area);
})
// .on("mouseover", hover_seasonsal_flu_vaccine_points)
// .on("mouseout", mouseleave_seasonal_flu_vaccine);

}

update_vaccine_24m_ts()

// Whenever the select value is changed fire the update vaccine_12m_ts function
d3.select("#vaccine_24_month_uptake_timeseries_button").on("change", function (d) {
  var selected_pcr_tested_area = d3
    .select("#vaccine_24_month_uptake_timeseries_button")
    .property("value");
    update_vaccine_24m_ts();
});

// ! Age 5 years time series figure interactive 

var svg_flu_uptake_timeseries_5_years = d3
.select("#vaccine_5_year_uptake_timeseries")
.append("svg")
.attr("width", ts_figure_width + margin.left + margin.right)
.attr("height", ts_figure_height + margin.top + margin.bottom)
.append("g")
.attr("transform", 
      "translate(" + margin.left + "," + margin.top + ")");


var ts_5_y_data = ltla_annual_df.filter(function (d) {
  return d.Age === '5 years' 
});

var vaccine_ts_5y_items = d3
.map(ts_5_y_data, function (d) {
  return d.Description;
})
.keys();

// vaccine_ts_5y_items = ['DTaP/IPV/Hib/HepB vaccine*', 'Meningococcal group B', 'Rotavirus']
console.log(ts_5_y_data)
d3.select("#vaccine_5_year_uptake_timeseries_button")
  .selectAll("myOptions")
  .data(vaccine_ts_5y_items)
  .enter()
  .append("option")
  .text(function (d) {
    return d;
  })
  .attr("value", function (d) {
    return d;
  });

var x_ts_5y = d3
.scalePoint()
.domain(['2017/18', '2018/19', '2019/20', '2020/21', '2021/22'])
.range([margin.left, ts_figure_width]);

var xAxis_ts_5y = svg_flu_uptake_timeseries_5_years
.append("g")
.attr("transform", "translate(0," + (ts_figure_height - margin.bottom - margin.top) + ")")
.call(
d3.axisBottom(x_ts_5y)
);

xAxis_ts_5y
.selectAll("text")
.style("text-anchor", 'middle')
.style("font-size", ".8rem");

var y_ts_5y = d3
.scaleLinear()
.domain([0.8,1])
.range([ts_figure_height - (margin.top + margin.bottom), margin.top])
.nice();

var yAxis_ts_5y = svg_flu_uptake_timeseries_5_years
.append("g")
.attr("transform", "translate(" + margin.left + ",0)")
.call(d3.axisLeft(y_ts_5y).tickFormat(d3.format(".1%")));

yAxis_ts_5y
.selectAll("text")
.style("font-size", ".8rem");

var chosen_5_year_vaccine = d3
.select("#vaccine_5_year_uptake_timeseries_button")
.property("value");

d3.select("#vaccine_5_year_uptake_timeseries_title").html(function (d) {
  return (
    'Figure - ' +
    chosen_5_year_vaccine +
    ' vaccine coverage compared to England; 2017/18 to 2021/22; ' +
    ' West Sussex compared to England; five year schedule;'
  );
});

var chosen_ts_5_y_data = ltla_annual_df.filter(function (d) {
  return d.Age === '5 years' &&
  d.Description === chosen_5_year_vaccine
});

// Group the data
var vaccine_ts_5y_areas_group = d3
.nest() 
.key(function (d) {
  return d.Area;
})
.entries(chosen_ts_5_y_data);

// Lines
var lines_ts_5_y = svg_flu_uptake_timeseries_5_years
.selectAll(".line")
.data(vaccine_ts_5y_areas_group)
.enter()
// .transition()
// .duration(1000)
.append("path")
.attr("id", "flu_lines")
.attr("class", "flu_all_lines")
.attr("stroke", function (d) {
  return area_colours(d.key);
})
.attr("d", function (d) {
  return d3
    .line()
    .x(function (d) {
      return x_ts_5y(d.Year);
    })
    .y(function (d) {
      return y_ts_5y(d.Proportion);
    })(d.values);
})
.style("stroke-width", 1)

// points
var dots_ts_5_y = svg_flu_uptake_timeseries_5_years
.selectAll("circles")
.data(chosen_ts_5_y_data)
.enter()
// .transition()
// .duration(1000)
.append("circle")
.attr("cx", function (d) {
  return x_ts_5y(d.Year);
})
.attr("cy", function (d) {
  return y_ts_5y(d.Proportion);
})
.style("fill", function (d) {
  return significance_colour(d.Significance);
})
.attr("r", function (d) {
  return circle_size_function(d.Area);
})
.attr("stroke", function (d) {
  return '#000';
})
// .on("mouseover", hover_seasonsal_flu_vaccine_points)
// .on("mouseout", mouseleave_seasonal_flu_vaccine);

function update_vaccine_5y_ts(){

// Retrieve the selected 5 year vaccine
var chosen_5_year_vaccine = d3
.select("#vaccine_5_year_uptake_timeseries_button")
.property("value");

d3.select("#vaccine_5_year_uptake_timeseries_title").html(function (d) {
  return (
    'Figure - ' +
    chosen_5_year_vaccine +
    ' vaccine coverage compared to England; 2017/18 to 2021/22; ' +
    ' West Sussex compared to England; 5 years schedule;'
  );
});

var chosen_ts_5_y_data = ltla_annual_df.filter(function (d) {
  return d.Age === '5 years' &&
  d.Description === chosen_5_year_vaccine
});

// Group the data
var vaccine_ts_5y_areas_group = d3
.nest() 
.key(function (d) {
  return d.Area;
})
.entries(chosen_ts_5_y_data);

// TODO handle missing data

lines_ts_5_y 
.data(vaccine_ts_5y_areas_group)
// .enter()
.transition()
.duration(1000)
.attr("d", function (d) {
  return d3
    .line()
    .x(function (d) {
      return x_ts_5y(d.Year);
    })
    .y(function (d) {
      return y_ts_5y(d.Proportion);
    })(d.values);
})

// points
dots_ts_5_y
.data(chosen_ts_5_y_data)
// .enter()
.transition()
.duration(1000)
.attr("cx", function (d) {
  return x_ts_5y(d.Year);
})
.attr("cy", function (d) {
  return y_ts_5y(d.Proportion);
})
.style("fill", function (d) {
  return significance_colour(d.Significance);
})
.attr("r", function (d) {
  return circle_size_function(d.Area);
})
// .on("mouseover", hover_seasonsal_flu_vaccine_points)
// .on("mouseout", mouseleave_seasonal_flu_vaccine);

}

update_vaccine_5y_ts()

// Whenever the select value is changed fire the update vaccine_12m_ts function
d3.select("#vaccine_5_year_uptake_timeseries_button").on("change", function (d) {
  var selected_pcr_tested_area = d3
    .select("#vaccine_5_year_uptake_timeseries_button")
    .property("value");
    update_vaccine_5y_ts();
});



// ! Seasonal flu

var svg_primary_school_flu_uptake_timeseries = d3
.select("#primary_school_flu_uptake_timeseries")
.append("svg")
.attr("width", flu_figure_width + margin.left + margin.right)
.attr("height", height + margin.top + margin.bottom)
.append("g")
.attr("transform", 
      "translate(" + margin.left + "," + margin.top + ")");

var seasons_flu = d3
.map(primary_school_flu_immunisations_df, function (d) {
  return d.Year_short;
})
.keys();
// seasons_flu = ['2019/20', '2020/21', '2021/22', '2022/23']

// Tooltip
var tooltip_seasonal_flu = d3
  .select("#primary_school_flu_uptake_timeseries")
  .append("div")
  .style("opacity", 0)
  .attr("class", "tooltip_class")
  .style("position", "absolute")
  .style("z-index", "10")
  .style("background-color", "white")
  .style("border", "solid")
  .style("border-width", "1px")
  .style("border-radius", "5px")
  .style("padding", "10px");

// Group the data
var seasonal_flu_areas_group = d3
.nest() // nest function allows to group the calculation per level of a factor (in this case connect lines within a group together)
.key(function (d) {
  return d.Area;
})
.entries(primary_school_flu_immunisations_df);

// Tooltip content
var hover_seasonsal_flu_vaccine_points = function (d) {
tooltip_seasonal_flu
.html(
"<h4>" +
  d.Area +
  ' - '+
  d.Year_short +
  ' season </h4><b> ' +
  d.Year +
  '</b><p>Proportion: <b>' +
  d3.format('.1%')(d.Proportion) +
  " </b>(95% CI: " +
  d3.format('.1%')(d.Lower_CL) +
  "-" +
  d3.format('.1%')(d.Upper_CL) +
  ')</p><p>There were <b>' +
  d3.format(',.0f')(d.Numerator) +
  ' vaccinations reported</b> for primary school aged children in this season with an estimated <b>' +
  d3.format(',.0f')(d.Denominator - d.Numerator) +
  ' children left to vaccinate</b>.'
)
.style("opacity", 1)
.style("top", event.pageY - 10 + "px")
.style("left", event.pageX + 10 + "px")
.style("visibility", "visible");
};

// No matter which function was called, on mouseleave restore everything back to the way it was.
var mouseleave_seasonal_flu_vaccine = function (d) {
  tooltip_seasonal_flu.style("visibility", "hidden");
};

var x_primary_flu = d3
.scalePoint()
.domain(seasons_flu)
.range([margin.left, flu_figure_width]);

var xAxis_primary_flu = svg_primary_school_flu_uptake_timeseries
.append("g")
.attr("transform", "translate(0," + (height - margin.bottom - margin.top) + ")")
.call(
  d3.axisBottom(x_primary_flu)
);

xAxis_primary_flu
.selectAll("text")
.style("text-anchor", 'middle')
.style("font-size", ".8rem");

var y_primary_flu = d3
.scaleLinear()
.domain([0,1])
.range([height - (margin.top + margin.bottom), margin.top])
.nice();

var yAxis_primary_flu = svg_primary_school_flu_uptake_timeseries
.append("g")
.attr("transform", "translate(" + margin.left + ",0)")
.call(d3.axisLeft(y_primary_flu).tickFormat(d3.format(".1%")));

yAxis_primary_flu
.selectAll("text")
.style("font-size", ".8rem");

// Lines
var lines_flu_time_series = svg_primary_school_flu_uptake_timeseries
.selectAll(".line")
.data(seasonal_flu_areas_group)
.enter()
.append("path")
.attr("id", "flu_lines")
.attr("class", "flu_all_lines")
.attr("stroke", function (d) {
  return area_colours(d.key);
})
.attr("d", function (d) {
  return d3
    .line()
    .x(function (d) {
      return x_primary_flu(d.Year_short);
    })
    .y(function (d) {
      return y_primary_flu(d.Proportion);
    })(d.values);
})
.style("stroke-width", 1)

// Points
var dots_vaccine_ts_1 = svg_primary_school_flu_uptake_timeseries
.selectAll("circles")
.data(primary_school_flu_immunisations_df)
.enter()
.append("circle")
.attr("cx", function (d) {
  return x_primary_flu(d.Year_short);
})
.attr("cy", function (d) {
  return y_primary_flu(d.Proportion);
})
.style("fill", function (d) {
  return significance_colour(d.Significance);
})
.attr("r", function (d) {
  return circle_size_function(d.Area);
})
.attr("stroke", function (d) {
  return '#000';
})
.on("mouseover", hover_seasonsal_flu_vaccine_points)
.on("mouseout", mouseleave_seasonal_flu_vaccine);

