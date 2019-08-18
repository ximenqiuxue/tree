package com.yimi.ssm.controller;

import com.yimi.ssm.bean.ResponseResult;
import com.yimi.ssm.model.Tree;
import com.yimi.ssm.service.TreeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping(value = "/tree")
public class TreeController {

    private static final Logger log = LoggerFactory.getLogger(TreeController.class);

    @Autowired
    TreeService treeService;

    @ResponseBody
    @RequestMapping(value = "findAll")
    public List<Tree> findAllNodes() {
        List<Tree> responseResult = new ArrayList<>();
        try {
            responseResult = treeService.findAll();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return responseResult;
    }

    @ResponseBody
    @RequestMapping(value = "/edit")
    public ResponseResult editNode(Tree tree) {
        /*Tree{id=101, name='', pId=null, open=true, checked=false, icon='null', children=[]}*/
        ResponseResult responseResult = new ResponseResult();
        try {
            treeService.updateEntity(tree);
            responseResult.setSuccess(true);
        } catch (Exception e) {
            e.printStackTrace();
            responseResult.setSuccess(false);
        }
        return responseResult;
    }

    @ResponseBody
    @RequestMapping(value = "/add")
    public ResponseResult addNode(Tree tree) {
        ResponseResult responseResult = new ResponseResult();
        try {
            treeService.addEntity(tree);
            responseResult.setSuccess(true);
        } catch (Exception e) {
            e.printStackTrace();
            responseResult.setSuccess(false);
        }
        return responseResult;
    }

    @ResponseBody
    @RequestMapping(value = "/delete")
    public ResponseResult deleteNodes(Integer Id) {
        ResponseResult responseResult = new ResponseResult();
        try {
            treeService.deleteById(Id);
            responseResult.setSuccess(true);
        } catch (Exception e) {
            e.printStackTrace();
            responseResult.setSuccess(false);
        }
        return responseResult;
    }
}

