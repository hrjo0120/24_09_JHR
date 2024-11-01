package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.example.demo.service.WeatherService;
import com.example.demo.vo.WeatherData;

@Controller
public class WeatherController {

	@Autowired
	private WeatherService weatherService;

	// 페이지에 접근할 때 city 파라미터 없이 페이지 로딩
    @GetMapping("/usr/home/weather")
    public String showWeatherPage() {
        return "/usr/home/weather";  // weather.jsp 페이지로 이동
    }

    // 검색 후 날씨 정보를 가져와서 표시
    @GetMapping("/usr/home/weather/search")
    public String getWeather(@RequestParam("city") String city, Model model) {
        WeatherData weatherData = weatherService.fetchWeather(city);
        model.addAttribute("weather", weatherData);
        return "/usr/home/weather";  // weather.jsp 페이지로 이동
    }
}
