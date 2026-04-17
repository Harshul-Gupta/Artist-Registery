package com.hars.springMVC;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hars.springMVC.model.Artist;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
	private final SpringMvcApplication springMvcApplication;

	HomeController(SpringMvcApplication springMvcApplication) {
		this.springMvcApplication = springMvcApplication;
	}

	@RequestMapping("/")
	public String home()
	{
		System.out.println("Homepage");
		return "index";
	}
	
	@RequestMapping("add")
	public String add(@RequestParam("num1") int first, @RequestParam("num2") int second, Model m)
	{
		int result= first + second;
		m.addAttribute("result", result);
		return "result";
	}
	
	@RequestMapping("addArtist")
	public String addArtist(@ModelAttribute Artist artist)
	{

		return "page";
	}
}
