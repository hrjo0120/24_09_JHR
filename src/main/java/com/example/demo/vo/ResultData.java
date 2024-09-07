package com.example.demo.vo;

import java.util.Map;

import com.example.demo.util.Ut;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ResultData<DT> {

	private String ResultCode;

	private String msg;

	private DT data1;	//DT: 제네릭으로 나중에 정할래

	private String data1Name;

	private Object data2;

	private String data2Name;
	
	private Map<String, Object> body;

	public ResultData(String ResultCode, String msg, Object... args) {
		this.ResultCode = ResultCode;
		this.msg = msg;
		this.body = Ut.mapOf(args);
	}

	public static <DT> ResultData<DT> from(String ResultCode, String msg) {
		return from(ResultCode, msg, null, null);

	}

	// from 이라는 메소드가 실행됐을 때, 어떻게 성공(실패)를 판별하는지
	public static <DT> ResultData<DT> from(String ResultCode, String msg, String data1Name, DT data1) {
		ResultData<DT> rd = new ResultData<DT>();
		rd.ResultCode = ResultCode;
		rd.msg = msg;
		rd.data1 = data1;
		rd.data1Name = data1Name;
		

		return rd;
	}
	
	public static <DT> ResultData<DT> from(String resultCode, String msg, String data1Name, DT data1, String data2Name,
			DT data2) {
		ResultData<DT> rd = new ResultData<DT>();
		rd.ResultCode = resultCode;
		rd.msg = msg;
		rd.data1Name = data1Name;
		rd.data1 = data1;
		rd.data2Name = data2Name;
		rd.data2 = data2;

		return rd;
	}

	// 보이는 이유? getter를 만들 때 is+대문자가 규칙이기 때문에 자동으로 필드에 있는 변수가 됨
	public boolean isSuccess() {
		return ResultCode.startsWith("S-");
	}

	public boolean isFail() {
		return isSuccess() == false;
	}

	public static <DT> ResultData<DT> newData(ResultData rd, String data1Name, DT newData) {
		return from(rd.getResultCode(), rd.getMsg(), data1Name, newData);
	}
	
	public void setData2(String data2Name, Object data2) {
		this.data2 = data2;
		this.data2Name = data2Name;
	}
}
