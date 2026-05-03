package com.hars.springMVC;

import java.sql.Savepoint;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hars.springMVC.model.Artist;
import com.hars.springMVC.model.ArtistRepo;

@Controller
public class ArtistController {
	
	@Autowired
	ArtistRepo artistRepo;
	
	@GetMapping("artist")
	@ResponseBody
	public List<Artist> getArtists(){
		List<Artist> artists= artistRepo.findAll();
		return artists;
	}
	
	@GetMapping("artist/{aid}")
	@ResponseBody
	public Optional<Artist> getArtist(@PathVariable("aid") int aid)
	{
		return artistRepo.findById(aid);
	}
	
	@PostMapping("artist")
	@ResponseBody
	public Artist addArtist(Artist artist) {
		artistRepo.save(artist);
		return artist;
	}
}
