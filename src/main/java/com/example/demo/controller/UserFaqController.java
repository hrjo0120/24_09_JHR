package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.BoardService;
import com.example.demo.service.FaqService;
import com.example.demo.vo.Board;
import com.example.demo.vo.Faq;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UserFaqController {

    @Autowired
    private Rq rq;

    @Autowired
    private FaqService faqService;
    
    @Autowired
	private BoardService boardService;

    // FAQ 목록 보기
    @RequestMapping("/usr/faq/list")
    public String showFaqList(HttpServletRequest req, Model model, @RequestParam(defaultValue = "4") int boardId,
                              @RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "title,body") String searchKeywordTypeCode,
                              @RequestParam(defaultValue = "") String searchKeyword) {

        Rq rq = (Rq) req.getAttribute("rq");

        Board board = boardService.getBoardById(boardId);

        // 검색 키워드가 없으면 빈 리스트를 반환하여 기본 화면에 아무것도 표시되지 않도록 처리
        if (searchKeyword.trim().isEmpty()) {
            model.addAttribute("faqs", List.of());
            model.addAttribute("faqsCount", 0);
            model.addAttribute("pagesCount", 0);
            model.addAttribute("board", board);
            model.addAttribute("page", page);
            model.addAttribute("searchKeywordTypeCode", searchKeywordTypeCode);
            model.addAttribute("searchKeyword", searchKeyword);
            model.addAttribute("boardId", boardId);

            return "usr/faq/list";
        }

        int faqsCount = faqService.getFaqsCount(boardId, searchKeywordTypeCode, searchKeyword);
        int itemsInAPage = 10;
        int pagesCount = (int) Math.ceil(faqsCount / (double) itemsInAPage);

        List<Faq> faqs = faqService.getForPrintFaqs(boardId, itemsInAPage, page, searchKeywordTypeCode, searchKeyword);

        model.addAttribute("faqs", faqs);
        model.addAttribute("faqsCount", faqsCount);
        model.addAttribute("pagesCount", pagesCount);
        model.addAttribute("board", board);
        model.addAttribute("page", page);
        model.addAttribute("searchKeywordTypeCode", searchKeywordTypeCode);
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("boardId", boardId);

        return "usr/faq/list";
    }

    // FAQ 상세 보기
    @RequestMapping(value = "/usr/faq/detail", produces = "text/html; charset=UTF-8")
    @ResponseBody
    public String showFaqDetail(@RequestParam("id") int id) {
        Faq faq = faqService.getFaqById(id);

        if (faq == null) {
            System.out.println("FAQ not found for ID: " + id);
            return "<div>해당 FAQ는 존재하지 않습니다.</div>";
        }

        String faqBody = faq.getBody();
        System.out.println("FAQ Body for ID " + id + ": " + faqBody);  // 로그 추가

        // HTML 형식으로 응답 반환
        return "<div>" + (faqBody != null ? faqBody : "내용이 없습니다.") + "</div>";
    }
}