package com.yimi.ssm.mapper;

import com.yimi.ssm.model.Tree;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TreeMapper {

    @Select("SELECT * FROM tree_test")
    List<Tree> queryAll();

    @Select("SELECT * FROM tree_test WHERE pid = #{pid}")
    List<Tree> queryById(Integer id);

    void updateByEntity(Tree tree);

    void addByEntity(Tree tree);

    void deleteByEntityId(Integer id);
}
