<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>ADMIN PAGE</title>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/series-label.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

<style>
#stockdata{
	width:700px;
	border:2px solid yellow;
    overflow:auto;
}
#container{
	width:700px;
	height:600px;
	border:2px solid red;
}
#total{
	width:700px;
	height:400px;
	border:2px solid blue;
}

#result{
   width:600px;
   height:600px;
   border:2px solid black;
   overflow:auto;
}
   
h4{
  border: 1px solid blue;
  margin: 1px;
  padding: 2px; 
}

</style>

<script>

/* ----------------------------------------------------------------------------------------- */
/*                                      ���Ȯ�� �ý���                                                                          */
/* ----------------------------------------------------------------------------------------- */
 
function displayStockData(datas) {
	var result = '';
	$(datas).each(function(index, data) {
		var result = '';
		result += '<h3 num="'+index+'">';
		result += '<p>' + data.name + ' : ' + data.stock + '</p>';
		result += '</h3>';
		$('#stockdata').append(result);
	});
};

function getStockData(){
	$.ajax({
		url : 'getstock.mc',
		async : false,
		success : function(result) {
			displayStockData(result);
		},
		error : function() {
			alert('Error...!1');
		}
	});
};


/* ----------------------------------------------------------------------------------------- */
/*                                      ��Ʈ �ý���                                                                               */
/* ----------------------------------------------------------------------------------------- */

//��Ʈ������ ǥ��
function chart(datas){
	var year = 2010;
	Highcharts.chart('container', {

	    title: {
	        text: '��ǥ ���� �޴� ���� ����, 2010-2018'
	    },

	    subtitle: {
	        text: 'Source: thesolarfoundation.com'
	    },

	    yAxis: {
	        title: {
	            text: 'Price of Burger'
	        }
	    },

	    xAxis: {
	        accessibility: {
	            rangeDescription: 'Range: 2010 to 2018'
	        }
	    },

	    legend: {
	        layout: 'vertical',
	        align: 'right',
	        verticalAlign: 'middle'
	    },

	    plotOptions: {
	        series: {
	            label: {
	                connectorAllowed: false
	            },
	            pointStart: 2010
	        }
	    },

	    series: datas,

	    responsive: {
	        rules: [{
	            condition: {
	                maxWidth: 500
	            },
	            chartOptions: {
	                legend: {
	                    layout: 'horizontal',
	                    align: 'center',
	                    verticalAlign: 'bottom'
	                }
	            }
	        }]
	    }

	});
};

//��Ʈ ������ ��������
function getData(){
	$.ajax({
		url:'getdata3',
		async:false,
		success:function(result){
			chart(result);
		},
		error:function(){
			alert('error');
		}
	});
	
};

/* ----------------------------------------------------------------------------------------- */
/*                                      �˻� �ý���                                                                               */
/* ----------------------------------------------------------------------------------------- */

//�˻������� ǥ��
function display(data) {
	$(data.documents).each(
			function(index, add) {
				var result = '';
				result += '<h4>' + "���� : " + add.title + '<br>' + "���� : "
						+ add.contents + '<br>' + "��¥ : " + add.datetime
						+ '<br>' + "��ũ : " + '<a href='+add.url+'>'
						+ add.url + '</a>' + '</h4>';
				$('#result').append(result);
			});
};

//�˻� ������ ��������
function getData2() {
	if ($('input[name="loc"]').val() != '') {
		var urlstr = 'https://dapi.kakao.com/v2/search/web.json'
		loc = $('input[name="loc"]').val();

		$.ajax({
					method : 'GET',
					url : urlstr,
					headers : {
						'Authorization' : 'KakaoAK 8bb4664642b1184f894533fe7edb0245'
					},
					data : {
						'query' : loc,
						'page' : 1,
						'size' : 4
					},
					success : function(data) {
						display(data);
					},
					error : function() {
						alert('error');
					}
				});

	} else {
		return;
	}
};

//--------------------------------------------------

$(document).ready(function() {
	
	getStockData();
	
	$('a').click(function() {
		getData();
	});

	$('button').click(function() {
		$('#result').empty();
		getData2();
	});

});
</script>

</head>
<body>
<h1>�ܹ��� �޴� ���� ��Ȳ</h1>
<div id="stockdata"></div>
<a href="#">Chart</a>
<div id="container"></div>
<button>�˻��ϱ�</button>
<input type="text" name="loc">
<div id="result"></div>
</body>
</html>