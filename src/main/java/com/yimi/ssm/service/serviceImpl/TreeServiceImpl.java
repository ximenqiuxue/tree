package com.yimi.ssm.service.serviceImpl;

import com.yimi.ssm.mapper.TreeMapper;
import com.yimi.ssm.model.Tree;
import com.yimi.ssm.service.TreeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class TreeServiceImpl implements TreeService {

    @Autowired
    TreeMapper treeMapper;

    @Override
    public List<Tree> findAll() {
        List<Tree> treeNodes = new ArrayList<>();
        List<Tree> treeData = treeMapper.queryAll();
        Map<Integer, Tree> treeMap = new HashMap<Integer, Tree>();
        for (Tree t: treeData) {
            treeMap.put(t.getId(), t);
        }
        for (Tree t : treeData){
            Tree child = t;
            if(child.getpId() == 0){
                treeNodes.add(t);
            }else {
                Tree parent = treeMap.get(child.getpId());
                parent.getChildren().add(child);
            }
        }
        return treeNodes;
    }

    @Override
    public void updateEntity(Tree tree) {
        treeMapper.updateByEntity(tree);
    }

    @Override
    public void addEntity(Tree tree) {
        treeMapper.addByEntity(tree);
    }

    @Override
    public void deleteById(Integer id) {
        treeMapper.deleteByEntityId(id);
    }

    private void queryChildrenNodes(Tree parent) {
        List<Tree> childrenNodes = treeMapper.queryById(parent.getId());

        for (Tree node : childrenNodes){
            queryChildrenNodes(node);
        }

        parent.setChildren(childrenNodes);
    }
}
