package com.yimi.ssm.service;

import com.yimi.ssm.model.Tree;
import java.util.List;


public interface TreeService {

    List<Tree> findAll();

    void updateEntity(Tree tree);

    void addEntity(Tree tree);

    void deleteById(Integer id);
}
