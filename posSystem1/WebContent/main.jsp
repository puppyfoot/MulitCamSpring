<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>POS SYSTEM</title>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2348a50ce2bdcf2f6cf00ff8ad5e426d"></script>

<style>
#product {
	width: 500px;
	height: 400px;
	border: 2px solid blue;
	overflow: auto;
}

#product>div {
	width: 150px;
	height: 200px;
	border: 1px dashed light gray;
	float: left;
	margin: 3px;
	font-size: 20px;
	font-weight: BOLD;
	border-radius: 20px;
	box-shadow: 5px 5px 5px gray;
}

#product>div>img {
	padding: 4px 0 0 4px;
	width: 80px;
	height: 80px;
}

#cart {
	width: 500px;
	height: 200px;
	border: 2px solid green;
	overflow: auto;
}

#cart>img {
	margin: 5px;
	border-radius: 20px;
	width: 30px;
	height: 30px;
}

#map {
	width: 600px;
	height: 600px;
	border: 2px solid blue;
}
</style>

<script>
/* ----------------------------------------------------------------------------------------- */
/*                                      �޴� �ý���                                                                               */
/* ----------------------------------------------------------------------------------------- */

var products = null;
var sum = 0;
var stock = [];

function display(datas) {
	var result = '';
	$(datas).each(function(index, data) {
		var result = '';
		result += '<div num="'+index+'">';
		result += '<img src="img/'+data.img+'">';
		result += '<p>' + data.name + '</p>';
		result += '<p>' + data.price + '</p>';
		result += '</div>';
		$('#product').append(result);
	});
};

function getData() {
	$.ajax({
		url : 'getdata4.mc',
		async : false,
		success : function(result) {
			display(result);
		},
		error : function() {
			alert('Error...!1');
		}
	});
};

function cart(n) {
	$.ajax({
		url : 'getdata4.mc',
		success : function(result) {
			var name = result[n].name;
			var price = result[n].price;
			var img = result[n].img;
			var resulthtml = '';
			resulthtml += '<img src="img/'+img+'">';
			resulthtml += name + ' ' + price + '<br>';
			$('#cart').append(resulthtml);
			sum += price;
			$('#sum>span').text(sum);
			stock.push(name);
			console.log(stock);
		},
		error : function() {
			alert('Error...!2');
		}
	});
};

function payment() {
	money = $('#payment > input').val();
	if (isNaN(money) == false) {
		if (sum == 0) {
			$('#payment > p').text('��ǰ�� �������ּ���');
		} else {
			if (money < sum) {
				$('#payment > p').text('���� �����մϴ�');
			} else {
				console.log('send: '+stock);
				var stockdata = {"stockdata":stock};
			    $.ajax({
			        url:"changestock.mc",
			        type:'GET',
			        data: stockdata,
			        traditional : true,
			        success:function(data){
						$('#payment > p').text(money - sum + '���� ���ҽ��ϴ�');
						alert('����Ϸ�! \n'+ (money - sum) + '���� ���ҽ��ϴ�');
						var total = $('#sum > span').text();
						window.location.reload(); 
			        },
			        error:function(jqXHR, textStatus, errorThrown){
			            alert("���� �߻�~~ ");
			            
			        }
			    });
			    stock = [];
			    
			}
		}
	} else {
		$('#payment > p').text('���� ������ �� �����ϴ�');
	}

};

/* ----------------------------------------------------------------------------------------- */
/*                                      ���� �ý���                                                                               */
/* ----------------------------------------------------------------------------------------- */
var map = null;

//���� ����Ʈ ������ ǥ��
function setMarkers(arrs) {
	$(arrs)
			.each(
					function(index, geo) {
						var marker = new kakao.maps.Marker({
							title : geo.name,
							position : new kakao.maps.LatLng(geo.lat,
									geo.lng)
						});
						marker.setMap(map);

						var iwContent = '<div style="padding:5px;"><a href="'+geo.url+'">'
								+ geo.name + '</a></div>', iwRemoveable = true;

						var infowindow = new kakao.maps.InfoWindow({
							content : iwContent,
							removable : iwRemoveable
						});

						kakao.maps.event.addListener(marker, 'click',
								function() {
									infowindow.open(map, marker);
								});

					});
};

//���� ���� �޾ƿ���
function getDataM(loc) {
	var arrs = null;
	$.ajax({
		url : 'geos.mc',
		async : false,
		data : {
			cmd : loc
		},
		success : function(data) {
			arrs = data;
		},
		error : function() {

		}
	});
	return arrs;
};

//���� ��ġ �̵�
function panTo(lat, lng, loc) {
	var moveLatLon = new kakao.maps.LatLng(lat, lng);
	map.panTo(moveLatLon);
	var arrs = getDataM(loc);
	setMarkers(arrs);
};

//���� ǥ�� ����
function mapDislapy() {
	var container = document.getElementById('map');
	var options = {
		center : new kakao.maps.LatLng(37.549530, 126.989045),
		level : 7
	};
	map = new kakao.maps.Map(container, options);
};

/* ----------------------------------------------------------------------------------------- */
/*                                      ���� �ý���                                                                               */
/* ----------------------------------------------------------------------------------------- */

//�������� ǥ��
function displayW(data) {
	var items = $(data).find('item');
	$(items).each(function(index, d) {
		if ($(d).find('category').text() == 'T1H') {
			var val = $(d).find('obsrValue').text();
			$('span:eq(0)').text('��� : ' + val + '��');
		}
		if ($(d).find('category').text() == 'REH') {
			var val = $(d).find('obsrValue').text();
			$('span:eq(1)').text('���� : ' + val + '%');
		}
	});
};

//���������� �޾ƿ���
function getdataW() {
	var urlstr = 'getweather.mc';
	$.ajax({
		url : urlstr,
		dataType : 'xml',
		success : function(data) {
			displayW(data);
		},
		error : function() {
			alert('error');
		}
	});
};

//--------------------------------------------------

$(document).ready(function() {
	getData(); //POS �ý��� ����
	mapDislapy(); //���� �ý��� ����

	//��ٱ��� ���
	$('#product > div').click(function() {
		console.log('test');
		var num = $(this).attr('num');
		cart(num); //�޴� Ŭ�� �� ��ٱ��Ͻ���
	});

	//���� or ��Ʈ ���� ��ư
	$('button:eq(0)').click(function() {
		$('#product > div').show();
	});
	$('button:eq(1)').click(function() {
		$('#product > div').hide();
	});

	//������ư
	$('button:eq(2)').click(function() {
		//seoul
		panTo(37.569530, 126.989045, 0); //���� ��ġ �̵�(����)
		getdataW(); //���� ǥ��
	});
	$('button:eq(3)').click(function() {
		//busan
		panTo(35.1719943, 129.1441646, 1); //���� ��ġ �̵�(�λ�)
		getdataW(); //���� ǥ��
	});

	$('#payment > button:eq(0)').click(function() {
		payment(); //���
	});
	
	$('#payment > button:eq(1)').click(function() {
		sum = 0;
		stock = [];
		$('#sum>span').text(sum);
		$('#cart').empty(); //������
	});

});
</script>

</head>
<body>
	<c:choose>
		<c:when test="${loginuser == null}">
			<h1>POS SYSTEM</h1>
		</c:when>
		<c:otherwise>
			<h1>POS SYSTEM (${loginuser.id }��)</h1>
		</c:otherwise>
	</c:choose>
	<button>��ǰ</button>
	<button>��Ʈ</button>
	<button>Seoul</button>
	<button>Busan</button>
	<span>���� ���</span>
	<span>���� ����</span>

	<div id="product"></div>
	<h1 id="sum">
		total:<span></span>
	</h1>
	<div id="cart"></div>
	<div id="payment">
		<input type="text" name="money" placeholder="���� �Է��ϼ���">
		<button>�����ϱ�</button>
		<button>���</button>
		<br>
		<p></p>
	</div>
	<div id="map"></div>
</body>
</html>