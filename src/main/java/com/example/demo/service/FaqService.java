package com.example.demo.service;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.FaqRepository;
import com.example.demo.vo.Faq;

@Service
public class FaqService {

    @Autowired
    private FaqRepository faqRepository;

    public FaqService(FaqRepository faqRepository) {
        this.faqRepository = faqRepository;
    }

    // 게시글 목록 가져오기 - 검색이 있는 경우에만 가져옴
    public List<Faq> getForPrintFaqs(int boardId, int itemsInAPage, int page, String searchKeywordTypeCode, String searchKeyword) {
        // 검색 키워드가 없을 경우 빈 리스트 반환
        if (searchKeyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        int limitFrom = (page - 1) * itemsInAPage;
        int limitTake = itemsInAPage;

        return faqRepository.getForPrintFaqs(boardId, limitFrom, limitTake, searchKeywordTypeCode, searchKeyword);
    }

    // 게시글 수 가져오기 - 검색이 있는 경우에만 유효
    public int getFaqsCount(int boardId, String searchKeywordTypeCode, String searchKeyword) {
        if (searchKeyword.trim().isEmpty()) {
            return 0;  // 검색 키워드가 없으면 게시글 수는 0
        }
        return faqRepository.getFaqsCount(boardId, searchKeywordTypeCode, searchKeyword);
    }

    // 특정 게시글 가져오기 (상세 보기)
    public Faq getFaqById(int id) {
        return faqRepository.getFaqById(id);
    }
}