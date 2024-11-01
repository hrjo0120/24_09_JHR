<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>날씨 정보 앱</title>
<!-- 제이쿼리 및 UI 라이브러리 추가 -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

<style>
/* 전체 배경 스타일 */
body {
	font-family: 'Arial', sans-serif; /* 폰트 스타일 설정 */
	background-color: #f7f9fc; /* 연한 회색 배경색 */
	color: #333; /* 텍스트 색상 */
	display: flex;
	justify-content: center; /* 수평 중앙 정렬 */
	align-items: center; /* 수직 중앙 정렬 */
	height: 100vh; /* 전체 화면 높이 */
	margin: 0;
}

/* 컨테이너 스타일 */
.container {
	background-color: #ffffff; /* 흰색 배경 */
	border-radius: 10px; /* 모서리 둥글게 */
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
	padding: 20px; /* 내부 여백 */
	width: 300px; /* 너비 설정 */
	text-align: center;
}

/* 검색창 스타일 */
.search-box {
	margin-bottom: 15px; /* 하단 여백 */
}

.search-box input[type="text"] {
	width: 80%; /* 입력 필드 너비 */
	padding: 8px; /* 내부 여백 */
	border: 1px solid #ccc; /* 테두리 색상 */
	border-radius: 5px; /* 테두리 둥글게 */
	font-size: 14px; /* 글자 크기 */
}

/* 날씨 정보 스타일 */
.weather-info {
	text-align: center;
	padding: 15px;
	border-radius: 10px;
	/* background-color: #f0f4f8; */
	margin-top: 10px;
}

.weather-info img {
	width: 100px;
	height: 100px;
	margin-bottom: 10px;
}

.temperature {
	font-size: 48px; /* 온도 글자 크기 */
	font-weight: bold; /* 글자 굵기 */
	margin: 0;
}

.condition {
	font-size: 20px; /* 상태 글자 크기 */
	font-weight: bold;
	margin: 5px 0;
	color: #555;
}

.additional-info {
	display: flex;
	justify-content: space-around;
	margin-top: 15px;
	font-size: 14px;
	color: #666; /* 부가 정보 색상 */
}

.additional-info div {
	text-align: center;
}

.additional-info div p:first-child {
	font-weight: bold;
	font-size: 16px;
}
</style>
</head>

<body>

	<div class="container">
		<h2>오늘의 날씨</h2>

		<!-- 검색창 -->
		<div class="search-box">
			<div class="search-box">
				<input type="text" id="cityInput" placeholder="도시 이름을 입력하세요" />
				<!-- 도시 이름 입력 필드 -->

			</div>
		</div>

		<!-- 날씨 정보 표시 영역 -->
		<div id="weatherInfo" class="weather-info" style="display: none;">
			<!-- 날씨 아이콘 -->
			<img id="weatherIcon" src="" alt="Weather Icon">
			<!-- 날씨 상세 정보 -->
			<div class="weather-details">
				<p id="temperature" class="temperature"></p>
				<!-- 온도 표시 -->
				<p id="condition" class="condition"></p>
				<!-- 날씨 상태 -->
				<div class="additional-info">
					<p id="humidity"></p>
					<!-- 습도 표시 -->
					<p id="windSpeed"></p>
					<!-- 풍속 표시 -->
				</div>
			</div>
		</div>
	</div>

	<script>
		// OpenWeather API 설정: 발급받은 API 키를 여기에 입력
		const apiKey = 'YOUR_API_KEY';

		$(document).ready(function() {
			// 날씨 조회 버튼 클릭 이벤트 핸들러
			$('#getWeatherBtn').click(function() {
				getWeatherByCityName();
			});

			// 입력 필드에서 Enter 키가 눌렸을 때 날씨 조회
			$('#cityInput').keyup(function(event) {
				if (event.key === "Enter") { // Enter 키가 눌리면
					getWeatherByCityName();
				}
			});
		});

		// 도시 이름을 기준으로 날씨를 조회하는 함수
		function getWeatherByCityName() {
			const city = $('#cityInput').val(); // 사용자 입력으로부터 도시 이름 가져오기

			// 입력된 도시 이름이 없는 경우 경고 표시 후 함수 종료
			if (!city) {
				alert("도시 이름을 입력하세요.");
				return;
			}

			// Geocoding API를 통해 도시의 위도와 경도 찾기 (한글 도시명 검색 지원)
			$.ajax({
				url : 'https://api.openweathermap.org/geo/1.0/direct?q=' + city
						+ '&limit=1&appid=' + apiKey,
				type : 'GET',
				dataType : 'json',
				success : function(data) {
					if (data.length > 0) {
						const lat = data[0].lat;
						const lon = data[0].lon;
						getWeatherByCoordinates(lat, lon, city); // 위도와 경도로 날씨 조회
					} else {
						alert("해당 도시를 찾을 수 없습니다.");
					}
				},
				error : function() {
					alert("도시 정보를 가져오는 데 실패했습니다.");
				}
			});
		}

		// 위도와 경도를 기준으로 날씨를 조회하는 함수
		function getWeatherByCoordinates(lat, lon, cityName) {
			$.ajax({
				url : 'https://api.openweathermap.org/data/2.5/weather?lat='
						+ lat + '&lon=' + lon + '&appid=' + apiKey
						+ '&units=metric&lang=kr',
				type : 'GET',
				dataType : 'json',
				success : function(data) {
					if (data.cod === 200) {
						displayWeather(data, cityName); // 날씨 정보 표시 함수 호출
					} else {
						alert("날씨 정보를 찾을 수 없습니다.");
					}
				},
				error : function() {
					alert("날씨 데이터를 가져오는 데 실패했습니다.");
				}
			});
		}

		// 현재 시간을 반환하는 함수
		function getCurrentTime() {
			const now = new Date();
			return now.toLocaleString('ko-KR');
		}

		// 날씨 정보를 화면에 표시하는 함수
		function displayWeather(data, cityName) {

			// 아이콘, 온도, 상태, 추가 정보 업데이트
			$('#weatherIcon').attr(
					'src',
					'http://openweathermap.org/img/wn/' + data.weather[0].icon
							+ '@2x.png');
			$('#temperature').text(Math.round(data.main.temp) + '°C'); // 온도 표시
			$('#condition').text(data.weather[0].description); // 날씨 상태
			$('#humidity').text('습도: ' + data.main.humidity + '%'); // 습도 표시
			$('#windSpeed').text('풍속: ' + data.wind.speed + ' m/s'); // 풍속 표시


			// 날씨 정보 영역을 보이도록 설정
			$('#weatherInfo').show();
		}
	</script>

</body>
</html>
