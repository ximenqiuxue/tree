package com.yimi.ssm.bean;

import java.util.Random;

public class ResponseResult {

    private boolean success;
    private Object data;

    @Override
    public String toString() {
        return "ResponseResult{" +
                "success=" + success +
                ", data=" + data +
                '}';
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}
