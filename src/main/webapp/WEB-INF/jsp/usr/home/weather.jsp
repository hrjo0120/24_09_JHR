<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>날씨 및 관광지 정보 앱</title>
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

.main-container {
	display: grid;
	grid-template-columns: 1fr 1fr;
	grid-template-rows: auto 1fr;
	gap: 20px;
	width: 100%;
	max-width: 800px;
}

.search-container {
	grid-column: 1/2;
	grid-row: 1/2;
}

.weather-container {
	grid-column: 1/2;
	grid-row: 2/3;
	display: flex;
    justify-content: center; /* 수평 중앙 정렬 */
    align-items: center; /* 수직 중앙 정렬 */
}

.tourist-container {
	margin-left: 40px; /* 관광지 컨테이너의 왼쪽 여백 */
	grid-column: 2/3;
	grid-row: 1/3;
}

/* 컨테이너 스타일 */
.container {
	background-color: #fff;
	border-radius: 10px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
	padding: 20px;
	width: 100%;
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

/* 관광지 카드 스타일 */
.tourist-info {
	margin-top: 20px;
	padding: 15px;
	border-radius: 10px;
	background-color: #f7f9fc;
	text-align: left;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
	display: grid;
	grid-template-columns: 1fr;
	gap: 10px;
}

.tourist-card {
	border: 1px solid #ddd;
	border-radius: 10px;
	padding: 10px;
	display: flex;
	flex-direction: column;
	align-items: center;
	background-color: #fff;
}

.tourist-card img {
	width: 100%;
	height: auto;
	border-radius: 10px;
	margin-bottom: 10px;
}

.tourist-card h4 {
	font-size: 18px;
	margin: 10px 0;
}

.tourist-card p {
	font-size: 14px;
	color: #666;
	text-align: center;
}
</style>
</head>

<body>

	<div class="main-container">
		<!-- 검색창 영역 -->
		<div class="container search-container">
			<h2>오늘의 날씨 및 관광지</h2>
			<div class="search-box">
				<input type="text" id="cityInput" placeholder="도시 이름을 입력하세요" />
				<button id="getWeatherBtn">조회</button>
			</div>
		</div>

		<!-- 날씨 정보 영역 -->
		<div class="container weather-container" >
			<div id="weatherInfo" class="weather-info" style="display: none;">
				<img id="weatherIcon" src="" alt="Weather Icon">
				<div class="weather-details">
					<p id="temperature" class="temperature"></p>
					<p id="condition" class="condition"></p>
					<div class="additional-info">
						<p id="humidity"></p>
						<p id="windSpeed"></p>
					</div>
				</div>
			</div>
		</div>

		<!-- 관광지 정보 영역 -->
		<div class="container tourist-container">
			<div id="touristInfo" class="tourist-info"></div>
		</div>
	</div>


	<script>
		// API 키
		const touristApiKey = 'YOUR_API_KEY'; // 공공 데이터 포털 관광 API 키
		const weatherApiKey = 'YOUR_API_KEY'; // OpenWeather API 키

		$(document).ready(function() {
			// 초기 상태: 날씨와 관광지 컨테이너 숨김
		    $('.weather-container').hide();
		    $('.tourist-container').hide();
			
		    $('#getWeatherBtn').click(function() {
		        const city = $('#cityInput').val(); // 사용자 입력값 가져오기
		        if (!city) {
		            alert("도시 이름을 입력하세요.");
		            return;
		        }

		        // 도시 이름으로 날씨 및 관광지 데이터 가져오기
		        getWeatherByCityName(city);

		        // 날씨와 관광지 컨테이너 보이기
		        $('.weather-container').show();
		        $('.tourist-container').show();
		    });

		    $('#cityInput').keyup(function(event) {
		        if (event.key === "Enter") {
		            const city = $('#cityInput').val(); // 사용자 입력값 가져오기
		            if (!city) {
		                alert("도시 이름을 입력하세요.");
		                return;
		            }

		            // 도시 이름으로 날씨 및 관광지 데이터 가져오기
		            getWeatherByCityName(city);

		            // 날씨와 관광지 컨테이너 보이기
		            $('.weather-container').show();
		            $('.tourist-container').show();
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
						+ '&limit=1&appid=' + weatherApiKey,
				type : 'GET',
				dataType : 'json',
				success : function(data) {
					if (data.length > 0) {
						const lat = data[0].lat;
						const lon = data[0].lon;
						getWeatherByCoordinates(lat, lon, city);
						getTouristInfoByCoordinates(lat, lon); // 위도, 경도를 사용하여 관광지 정보 가져오기
					} else {
						alert("해당 도시를 찾을 수 없습니다.");
					}
				},
				error : function(error) {
					alert("도시 정보를 가져오는 데 실패했습니다.");
				}
			});
		}

		// 위도와 경도를 기준으로 날씨를 조회하는 함수
		function getWeatherByCoordinates(lat, lon, cityName) {
			$.ajax({
				url : 'https://api.openweathermap.org/data/2.5/weather?lat='
						+ lat + '&lon=' + lon + '&appid=' + weatherApiKey
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

		let currentPage = 1; // 현재 페이지 상태
		const itemsPerPage = 5; // 한 페이지에 표시할 관광지 개수
		let currentLat = null; // 현재 위도
		let currentLon = null; // 현재 경도

		function getTouristInfoByCoordinates(lat, lon) {
			currentLat = lat; // 현재 위도 저장
			currentLon = lon; // 현재 경도 저장

			$
					.ajax({
						url : 'https://apis.data.go.kr/B551011/KorService1/locationBasedList1?serviceKey='
								+ touristApiKey
								+ '&numOfRows='
								+ itemsPerPage
								+ '&pageNo='
								+ currentPage
								+ '&MobileApp=AppTest&_type=json&MobileOS=ETC&mapX='
								+ lon
								+ '&mapY='
								+ lat
								+ '&radius=20000&contentTypeId=12',
						type : 'GET',
						dataType : 'json',
						success : function(data) {
							if (data.response.body.totalCount > 0) {
								displayTouristInfo(data);
								updatePagination(data.response.body.totalCount);
							} else {
								$('#touristInfo').html(
										'<p>해당 지역에 대한 관광 정보가 없습니다.</p>');
							}
						},
						error : function(error) {
							console
									.error("Error fetching tourist info:",
											error); // 에러내용 출력
							alert("관광 정보를 가져오는 데 실패했습니다.");
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

		// 관광지 정보를 화면에 표시하는 함수
		function displayTouristInfo(data) {
			const touristInfoContainer = document.getElementById("touristInfo");
			touristInfoContainer.innerHTML = ''; // 기존 내용 초기화

			const items = data.response.body.items.item;

			items.forEach(function(item) {
				const card = document.createElement('div');
				card.className = 'tourist-card';

				/* const img = document.createElement('img');
				img.src = item.firstimage || 'https://via.placeholder.com/150';
				img.alt = item.title || '이미지 없음'; */

				const title = document.createElement('h4');
				title.textContent = item.title || '명소 정보 없음';

				const addr = document.createElement('p');
				addr.textContent = item.addr1 || '주소 미제공';

				/* card.appendChild(img); */
				card.appendChild(title);
				card.appendChild(addr);

				touristInfoContainer.appendChild(card);
			});
		}
		
		function updatePagination(totalCount) {
	        const totalPages = Math.ceil(totalCount / itemsPerPage); // 총 페이지 수 계산
	        let paginationHtml = '';

	        // 이전 페이지 버튼 추가
	        if (currentPage > 1) {
	            paginationHtml += '<button id="prevPage" onclick="changePage(' + (currentPage - 1) + ')">이전</button>';
	        }

	        // 다음 페이지 버튼 추가
	        if (currentPage < totalPages) {
	            paginationHtml += '<button id="nextPage" onclick="changePage(' + (currentPage + 1) + ')">다음</button>';
	        }

	        document.getElementById("touristInfo").innerHTML += paginationHtml;
	    }

	    function changePage(page) {
	        currentPage = page;  // 페이지 변경
	        getTouristInfoByCoordinates(currentLat, currentLon);  // 새로운 페이지의 데이터를 가져옵니다
	    }
	</script>

</body>
</html>
