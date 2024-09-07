package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.util.crawlTest;

@Controller
public class UserHomeController {
	@RequestMapping("/usr/home/main")
	public String showMain() {
		return "/usr/home/main";
	}
	
	//ResponseBody가 없어야함. 있고 없고 차이가 있음
	@RequestMapping("/")
	public String showRoot() {
		return "redirect:/usr/home/main";
	}
	
	@RequestMapping("/usr/crawl")
	public String doCrawl() {

		crawlTest.crawl();

		return "redirect:/usr/home/main";
	}
	
}

//	private int count;
//	int num;
//	
//	public UserHomeController() {
//		count = 0;
//	}
////	int count = -1;
//	
//	@RequestMapping("/usr/home/main")
//	@ResponseBody
//	public String showMain() {
//		return "안녕하세요";
//	}
//	
//	@RequestMapping("/usr/home/main2")
//	@ResponseBody
//	public String showMain2() {
//		return "잘가";
//	}
//	
//	@RequestMapping("/usr/home/main3")
//	@ResponseBody
//	public int showMain3() {
//		int a = 1;
//		int b = 2;
//		return a + b;
//	}
//	
//	@RequestMapping("/usr/home/getCount")
//	@ResponseBody
//	public int getCount() {
//		return count++;
//	}
//	
//	
////	@RequestMapping("/usr/home/main5")
////	@ResponseBody
////	public String showMain5() {
////		count = 0;
////		return "count 값 0으로 초기화";
////	}
//	
//	@RequestMapping("/usr/home/setCount")
//	@ResponseBody
//	public String setCount() {
//		count = 0;
//		return "count 값 0으로 초기화";
//	}
//	
//	// 매개변수로 받은 것을 필드에 넣는 중
//	@RequestMapping("/usr/home/setCountValue")
//	@ResponseBody
//	public String setCountValue(int value) {
//		//인자는 ?value=?? 로 주면 됨
//		//파라미터의 이름은 value 여야 함. 받기로한 인자의 값이 value 이기 때문에
//		// ex) http://localhost:8080/usr/home/setCountValue?value=50
//		this.count = value;
//		return "count 값 " + value + "으로 초기화";
//	}
//	
//	@RequestMapping("/usr/home/getInt")
//	@ResponseBody
//	public int getInt() {
//		return 1;		// 출력: 1
//	}
//	
//	@RequestMapping("/usr/home/getString")
//	@ResponseBody
//	public String getString() {
//		return "abc";	// 출력: abc
//	}
//	
//	@RequestMapping("/usr/home/getBoolean")
//	@ResponseBody
//	public Boolean getBoolean() {
//		return true;	// 출력: true
//	}
//	
//	@RequestMapping("/usr/home/getDouble")
//	@ResponseBody
//	public Double getDouble() {
//		return 3.14;	// 출력: 3.14
//	}
//	
//	@RequestMapping("/usr/home/getMap")
//	@ResponseBody
//	public Map<String, Object> getMap() {
//		Map<String, Object> map = new HashMap<>();
//		
//		map.put("철수나이", 11);
//		map.put("영수나이", 12);
//		
//		return map;		// 출력: {"영수나이":12,"철수나이":11}
//						// 주소가 아니라 안에 들어있는 내용이 그대로 출력됨
//	}
//	
//	@RequestMapping("/usr/home/getList")
//	@ResponseBody
//	public List<String> getList() {
//		List<String> list = new ArrayList<>();
//		
//		list.add("철수나이");
//		list.add("영수나이");
//		
//		return list;		// 출력: ["철수나이","영수나이"]
//	}
//	
//	@RequestMapping("/usr/home/getArticle")
//	@ResponseBody
//	public Article getArticle() {
//		Article article = new Article(1, "제목1", "내용1");
//
//		return article;		// 출력: {"id":1,"title":"제목1","body":"내용1"}
//	}
//}
//
//@Data
//@AllArgsConstructor
//@NoArgsConstructor
//class Article {
//	
//	int id;
//	String title;
//	String body;
//	
////	상단의 @AllArgsConstructor, @NoArgsConstructor 가 있으면 하단에 생성자를 쓰지 않아도 된다.
////	public Article(int id, String title, String body) {
////		this.id = id;
////		this.title = title;
////		this.body = body;
////	}
////	
////	public int getId() {
////		return id;
////	}
////	
////	public String getTitle() {
////		return title;
////	}
////	
////	public String getbody() {
////		return body;
////	}
//}
