package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Faq {
    
    private int id;  // FAQ 게시글 ID
    private String regDate;  // 등록일
    private String updateDate;  // 수정일
    private int memberId;  // 작성자 ID
    private int boardId;  // 게시판 ID
    private String title;  // FAQ 제목
    private String body;  // FAQ 내용

    // 추가적인 필드 (예: 작성자 닉네임)
    private String extra__writer;  // 작성자 닉네임
}
