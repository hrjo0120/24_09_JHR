package com.example.demo.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.demo.vo.WeatherData;

@Service
public class WeatherService {
	private final String apiKey = "YOUR_API_KEY";
	private final String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s&units=metric";

	public WeatherData fetchWeather(String city) {
		RestTemplate restTemplate = new RestTemplate();
		String url = String.format(apiUrl, city, apiKey);
		return restTemplate.getForObject(url, WeatherData.class);
	}
}
