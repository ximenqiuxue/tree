<%--
  Created by IntelliJ IDEA.
  User: design
  Date: 2019/8/15
  Time: 9:17
  To change this template use File | Settings | File Templates.
--%>
<%@page pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html lang="zh-CN">
<head>
    <title>目录结构</title>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <base href=" <%=basePath%>">
    <script src="../../static/common/commonjs.js" charset="utf-8"></script>
    <script src="../../static/common/commoncss.js" charset="utf-8"></script>
    <style type="text/css">
        .ztree li span.button.add {
            margin-left: 2px;
            margin-right: -1px;
            background-position: -144px 0;
            vertical-align: top;
            *vertical-align: middle
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-6 col-md-offset-3" style="margin-top: 20px">
            <div class="panel panel-success">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <span class="glyphicon glyphicon-th-list"></span>
                        目录
                    </h3>
                </div>
                <div class="panel-body">
                    <ul id="treeDemo" class="ztree"></ul>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- 注意：如果你直接复制所有代码到本地，上述js路径需要改成你本地的 -->
<script type="text/javascript">
    var setting = {
        async: {
            enable: true,
            url: "/tree/findAll.do"
        },
        view: {
            addHoverDom: addHoverDom,
            removeHoverDom: removeHoverDom,
            selectedMulti: false
        },
        edit: {
            enable: false,
            editNameSelectAll: true
        },
        data: {
            simpleData: {
                enable: true
            }
        },
        callback: {
            beforeEditName: beforeEditName,
            beforeRemove: beforeRemove,
            beforeRename: beforeRename
        }
    };

    var className = "dark"; var layer; var newCount = 1;
    layui.use('layer', function () {
        layer = layui.layer;
    });

    function addHoverDom(treeId, treeNode) {
        var sObj = $("#" + treeNode.tId + "_span");
        if (treeNode.editNameFlag || $("#addBtn_" + treeNode.tId).length > 0) return;
        var addStr = "<span class='button add' id='addBtn_" + treeNode.tId + "' title='添加' onfocus='this.blur();'></span>";
        var editStr = "<span class='button edit' id='editBtn_" + treeNode.tId + "' title='编辑' οnfοcus='this.blur();'></span>";
        var removeStr = "<span class='button remove' id='removeBtn_" + treeNode.tId + "' title='删除' οnfοcus='this.blur();'></span>";
        if(treeNode.children.length < 1 && treeNode.level !== 0) {
            sObj.after(addStr, editStr, removeStr);
        }else{
            sObj.after(addStr, editStr);
        }
        //新增
        var addBtn = $("#addBtn_" + treeNode.tId);
        if (addBtn) addBtn.bind("click", function () {
            // console.log('addBtn.bind');
            beforeAddName(treeId, treeNode)
        });
        //编辑
        var editBtn = $("#editBtn_" + treeNode.tId);
        if(editBtn) editBtn.bind("click",function () {
            // console.log('editBtn.bind');
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            zTree.selectNode(treeNode);
            zTree.editName(treeNode);
            return false;
        });
        //删除
        var removeBtn = $("#removeBtn_" + treeNode.tId);
        if(removeBtn) removeBtn.bind("click",function () {
            // console.log('removeBtn.bind');
            beforeRemove(treeId, treeNode);
        })
    }

    //增加回调
    function beforeAddName(treeId, treeNode) {
        var zTree = $.fn.zTree.getZTreeObj("treeDemo");
        //当前节点id乘10加1
        var newId = (treeNode.id) * 10 + treeNode.children.length + newCount;
        zTree.addNodes(treeNode, {id: newId, pId: treeNode.id, name: "new node" + newId});
        var loadingIndex = null;
        $.ajax({
            type: "POST",
            url: "/tree/add.do",
            data: {
                "id": newId,
                "name": "new node" + newId,
                "pId": treeNode.id
            },
            beforeSend : function(){
                loadingIndex = layer.msg('处理中', {icon: 16});
            },
            success: function (result) {
                if (result.success) {
                    // 刷新数据
                    layer.close(loadingIndex);
                    zTree.reAsyncChildNodes(null, "refresh");
                } else {
                    layer.msg("节点添加发生错误，请刷新数据！", {time: 2000, icon: 5, shift: 6}, function () {
                    });
                }
            }
        });
        return false;
    }

    //进入编辑状态
    function beforeEditName(treeId, treeNode) {
        // console.log('beforeEditName');
        className = (className === "dark" ? "" : "dark");
        var zTree = $.fn.zTree.getZTreeObj("treeDemo");
        zTree.selectNode(treeNode);
        zTree.editName(treeNode);
        return false;
    }

    // 编辑回调
    function beforeRename(treeId, treeNode, newName, isCancel) {
        // console.log('beforeRename');
        className = (className === "dark" ? "" : "dark");
        if (newName.length == 0) {
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            zTree.cancelEditName();
            layer.msg("节点名称不能为空", {time: 2000, icon: 0, shift: 6}, function () {
            });
            return false;
        }
        if(treeNode.name != newName){
            var loadingIndex = null;
            $.ajax({
                type: "POST",
                url: "/tree/edit.do",
                data: {
                    "id": treeNode.id,
                    "name": newName
                },
                beforeSend : function(){
                    loadingIndex = layer.msg('处理中', {icon: 16});
                },
                success: function (result) {
                    if (result.success) {
                        // 刷新数据
                        var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                        layer.close(loadingIndex);
                        zTree.updateNode(treeNode);
                    } else {
                        layer.msg("节点修改发生错误", {time: 2000, icon: 5, shift: 6}, function () {
                        });
                    }

                }
            });
        }
    }

    //删除回调
    function beforeRemove(treeId, treeNode) {
        className = (className === "dark" ? "" : "dark");
        var zTree = $.fn.zTree.getZTreeObj("treeDemo");
        zTree.selectNode(treeNode);
        var loadingIndex = null;
        if (treeNode.children.length < 1) {
            layer.confirm('确定要删除吗', {icon: 3, title: '提示', skin: 'layer-ext-moon'}, function (index) {
                $.ajax({
                    type: "POST",
                    url: "/tree/delete.do",
                    data: {
                        "Id": treeNode.id,
                    },
                    beforeSend : function(){
                        loadingIndex = layer.msg('处理中', {icon: 16});
                    },
                    success: function (result) {
                        if (result.success) {
                            // 刷新数据
                            zTree.removeNode(treeNode);
                            layer.close(loadingIndex);
                            zTree.reAsyncChildNodes(null, "refresh");
                        } else {
                            layer.msg("节点删除发生错误", {time: 2000, icon: 5, shift: 6}, function () {
                            });
                        }
                    }
                });
                layer.close(index);
            });
        } else {
            layer.msg("请先删除子节点", {time: 2000, icon: 0, shift: 6}, function () {
            });
        }
        return false;
    }

    //鼠标离开失去绑定
    function removeHoverDom(treeId, treeNode) {
        $("#addBtn_" + treeNode.tId).unbind().remove();
        $("#editBtn_" + treeNode.tId).unbind().remove();
        $("#removeBtn_" + treeNode.tId).unbind().remove();
    }

    //编辑状态下全部选中文字
    function selectAll() {
        var zTree = $.fn.zTree.getZTreeObj("treeDemo");
        zTree.setting.edit.editNameSelectAll = $("#selectAll").attr("checked");
    }

    $(document).ready(function () {
        $.fn.zTree.init($("#treeDemo"), setting);
        $("#selectAll").bind("click", selectAll);
    });

    /*function onClick(treeNode) {
        var ids = [];
        ids = getAllChildrenNodes(treeNode, ids);
        console.log(ids);
        return ids;
    }

    function getAllChildrenNodes(treeNode, result) {
        var childrenNodes = treeNode.children;
        if (childrenNodes) {
            for (var i = 0; i < childrenNodes.length; i++) {
                result.push(childrenNodes[i].id);
                result = getAllChildrenNodes(childrenNodes[i], result);
            }
        }
        return result;
    }*/
</script>
</body>
</html>
