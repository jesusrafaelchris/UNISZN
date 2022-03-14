//
//  courseArray.swift
//  coords
//
//  Created by Christian Grinling on 25/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class RelatedCourses {
    
    var output = [String]()
    
    let Business = ["Business Administration",
    "Economics",
    "Finance and Management",
    "International Business",
    "Marketing",
    "Banking and Finance",
    "Accounting",
    "International Management",
    "Business Analytics",
    "Entrepreneurship"]
    
    let NaturalSciences = ["Biology",
    "Marine Biology",
    "Mathematics",
    "Computer Science",
    "Chemistry",
    "Physics & Astronomy",
    "Earth Science",
    "Biochemistry"]
    
    let Engineering = ["Chemical Engineering",
    "Aeronautics",
    "Bioengineering",
    "Civil and Environmental Engineering",
    "Electronic Engineering",
    "Mechanical Engineering"]
    
    let Medicine = ["Surgery",
    "Dentistry",
    "Molecular Medicine",
    "Veterinary Surgery",
    "Nursing",
    "Psychotherapy",
    "Biomedicine",
    "Pharmacy",
    "Medical Biotechnology"]
    
    let Law = ["Bachelor of Law",
    "Criminology and Law",
    "Master of Laws",
    "Civil Law",
    "International Human Rights Law",
    "Criminal Justice"]
    
    let SocialSciences = ["Psychology",
    "Political Science",
    "History",
    "Linguistics",
    "Anthropology",
    "English",
    "Politics",
    "Geography"]

    let Sports = ["Sports and Exercise Sciences",
    "Sports Science and Physiology",
    "Sport & Exercise Nutrition"]
    
    let Media = ["Journalism",
    "Film & TV Studies",
    "Screenwriting",
    "Digital Media",]
    
    let Arts = ["Fine Art Painting",
    "Graphic Design",
    "Fashion Design",
    "Architecture"]
    
    let Languages = ["French",
    "Spanish",
    "German",
    "Latin",
    "Italian",
    "Japanese",
    "Chinese"]
    
    func getRelatedCourses(userCourse: String) -> [String] {
        let courses = [Business, NaturalSciences, Engineering, Medicine, Law, SocialSciences, Sports, Media, Arts, Languages]
        for course in courses {
            if course.contains(userCourse) {
                for i in (0...course.count - 1) {
                    let result = course[i]
                    output.append(result)
                }
                
            }
        }
        return output
    }


}
