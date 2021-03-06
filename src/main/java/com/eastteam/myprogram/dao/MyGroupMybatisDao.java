package com.eastteam.myprogram.dao;

import java.util.List;

import com.eastteam.myprogram.entity.Group;
import com.eastteam.myprogram.entity.GroupMember;
import com.eastteam.myprogram.entity.User;

@MyBatisRepository
public interface MyGroupMybatisDao {
	public List<Group> search(String userId);
	public void insertGroup(Group group);
	public void updateGroup(Group group);
	public void deleteGroup(Long groupId);
	public Group getSelectedGroup(Long groupId);
	public List<Group> allGroupsByUser(String userId);
	public void insertRelatedMembers(List<GroupMember> groupMembers);
	public List<GroupMember> getRelatedMembers(Long groupId);
	public void deleteRelatedMembers(Long groupId);
	public void updateRelatedMembers(List<GroupMember> groupMembers);
}
