package com.hars.springMVC.model;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
public interface ArtistRepo extends JpaRepository<Artist, Integer>{

	//Artist getByName(String aname);
	
	@Query("from Artist where name= :aname")
	Artist getByName(@Param("aname") String name);
	
	@Query("from Artist where name is not null order by id")
	List<Artist> findAll();

}
