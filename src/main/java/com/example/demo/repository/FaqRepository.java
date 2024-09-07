package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.demo.vo.Faq;

@Mapper
public interface FaqRepository {

	// 특정 검색 조건에 맞는 FAQ 목록 가져오기
	@Select("""
			<script>
			    SELECT F.*, M.nickname AS extra__writer
			    FROM faq AS F
			    INNER JOIN `member` AS M
			    ON F.memberId = M.id
			    WHERE 1
			    <if test="boardId != 0">
			        AND F.boardId = #{boardId}
			    </if>
			    <if test="searchKeyword != ''">
			        AND F.title LIKE CONCAT('%', #{searchKeyword}, '%')  <!-- title 필드에서만 검색 -->
			    </if>
			    ORDER BY F.id DESC
			    <if test="limitFrom >= 0">
			        LIMIT #{limitFrom}, #{limitTake}
			    </if>
			</script>
			""")
	public List<Faq> getForPrintFaqs(int boardId, int limitFrom, int limitTake, String searchKeywordTypeCode,
			String searchKeyword);

	// 특정 검색 조건에 맞는 FAQ 게시글 수 가져오기
	@Select("""
			<script>
			    SELECT COUNT(*)
			    FROM faq AS F
			    INNER JOIN `member` AS M
			    ON F.memberId = M.id
			    WHERE 1
			    <if test="boardId != 0">
			        AND F.boardId = #{boardId}
			    </if>
			    <if test="searchKeyword != ''">
			        <choose>
			            <when test="searchKeywordTypeCode == 'title'">
			                AND F.title LIKE CONCAT('%', #{searchKeyword}, '%')
			            </when>
			            <when test="searchKeywordTypeCode == 'body'">
			                AND F.`body` LIKE CONCAT('%', #{searchKeyword}, '%')
			            </when>
			            <when test="searchKeywordTypeCode == 'writer'">
			                AND M.nickname LIKE CONCAT('%', #{searchKeyword}, '%')
			            </when>
			            <otherwise>
			                AND F.title LIKE CONCAT('%', #{searchKeyword}, '%')
			                OR F.`body` LIKE CONCAT('%', #{searchKeyword}, '%')
			            </otherwise>
			        </choose>
			    </if>
			</script>
			""")
	public int getFaqsCount(int boardId, String searchKeywordTypeCode, String searchKeyword);

	// 특정 FAQ 게시글의 상세 정보 가져오기
	@Select("""
			SELECT F.*, M.nickname AS extra__writer
			FROM faq AS F
			INNER JOIN `member` AS M
			ON F.memberId = M.id
			WHERE F.id = #{id}
			""")
	public Faq getFaqById(int id);
}
