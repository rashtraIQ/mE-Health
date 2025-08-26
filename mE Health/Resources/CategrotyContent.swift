//
//  CategrotyContent.swift
//  mE Health
//
//  Created by Ishant Tiwari on 14/08/25.
//

import Foundation

enum DateRange {
    case lastYear
    case allTime
}

let firstname = userProfileData?.first_name ?? ""
let last_name = userProfileData?.last_name ?? ""

let getdateRange: DateRange = .lastYear



var getPromtTitleBehavior = """
          
                                              Hey \(firstname + " " + last_name), let’s take a supportive look at your mental health risks (e.g., depression, anxiety) based on your health data within \(getdateRange == .lastYear ? "the last year" : "all time"). We’re checking your conditions, meds, and more to keep you feeling your best with some friendly insights. 😊
        
        

        **Patient Demographics**:
        """

var getPromtTaskBehavior = """
              \n**Task**: Estimate mental health risks (e.g., depression, anxiety) based on conditions, vitals, lab results, medications, imaging, allergies, procedures, appointments, immunizations, encounters, and documents. Incorporate chronic condition risks (e.g., chronic pain contributing to depression), social determinants of health (e.g., socioeconomic barriers impacting mental health), health goal feasibility (e.g., mental health affecting goal achievement), and polypharmacy side effects (e.g., medications causing mood changes) for a comprehensive assessment. Address me by name (\(firstname + " " + last_name)) in a friendly response with risk description, recommendations, and confidence score.
              """


var getPromtTitleChoronic = """
        Hey \(firstname + " " + last_name), let's check for any potential undiagnosed chronic conditions (like hypertension or asthma) based on your health data within \(getdateRange == .lastYear ? "the last year" : "all time"). We'll look at everything from vitals to labs to give you a full picture and some friendly advice. 😊

        **Patient Demographics**:
        """

var getPromtTaskChoronic = """
        \n**Task**: Estimate potential undiagnosed chronic conditions (e.g., hypertension, asthma) using vitals, lab results, medications, imaging, allergies, procedures, appointments, immunizations, encounters, and documents. Incorporate polypharmacy risks (from medications, e.g., drug interactions), gaps in care (e.g., overdue tests or follow-ups), imaging trends (e.g., condition progression), and condition validation (e.g., confirming diagnoses) for a comprehensive assessment. Address me by name (\(firstname + " " + last_name)) in a friendly response with risk description, recommendations, and confidence score.
        """

var getPromtTitleGaps = """
        Hey \(firstname + " " + last_name), let’s make sure your care plan is rock-solid! We’re checking your health data within \(getdateRange == .lastYear ? "the last year" : "all time") to spot any gaps in care, like overdue tests or follow-ups, using everything from your conditions to imaging. We’ll give you some friendly tips to fill those gaps and keep you thriving. 😊

        **Patient Demographics**:
        """

var getPromtTaskGaps = """
        \n**Task**: Identify missing care elements (e.g., overdue imaging tests, follow-ups) using conditions, vitals, lab results, medications, imaging, allergies, procedures, appointments, immunizations, encounters, and documents. Incorporate preventive care needs (e.g., missing screenings like colonoscopies), medication adherence risks (e.g., non-adherence causing gaps), social determinants of health (e.g., access barriers leading to gaps), and imaging trends (e.g., overdue follow-ups based on imaging history) for a comprehensive care plan. Address me by name (\(firstname + " " + last_name)) in a friendly response with gap descriptions, recommendations, and confidence scores.
        """

var getPromtTitleMedicationAdhere = """
        Hey \(firstname + " " + last_name), let’s make sure you’re staying on track with your medications! We’re diving into your health data within \(getdateRange == .lastYear ? "the last year" : "all time") to assess any risks of missing doses, looking at everything from your meds to appointments. We’ll give you some friendly tips to keep you feeling great. 😊

        **Patient Demographics**:
        """

var getPromtTaskMedicationAdhere = """
        \n**Task**: Assess risks of medication non-adherence using medication requests, vitals, lab results, imaging, allergies, procedures, appointments, immunizations, encounters, and documents. Incorporate polypharmacy risks (e.g., drug interactions from multiple medications), gaps in care (e.g., missed follow-ups leading to non-adherence), health goal feasibility (e.g., adherence affecting weight loss goals), and chronic condition management (e.g., non-adherence worsening hypertension) for a comprehensive analysis. Address me by name (\(firstname + " " + last_name)) in a friendly response with risk level, reasons, recommendations, and confidence score.
        """

var getPromtTitlePolypharmacy = """
        Hey \(firstname + " " + last_name), let’s check if your medications are playing nice together! We’re diving into your health data within \(getdateRange == .lastYear ? "the last year" : "all time") to spot any risks from taking multiple meds, looking at everything from your prescriptions to imaging. We’ll give you some friendly tips to stay on top of your health. 😊

        **Patient Demographics**:
        """

var getPromtTaskPolypharmacy = """
        \n**Task**: Assess polypharmacy risks from multiple medications using medication requests, vitals, lab results, imaging, allergies, procedures, appointments, immunizations, encounters, and documents. Incorporate medication adherence risks (e.g., non-adherence increasing polypharmacy issues), chronic condition management (e.g., multiple meds indicating chronic issues), gaps in care (e.g., missed pharmacist reviews), and behavioral health risks (e.g., polypharmacy causing mental health side effects) for a comprehensive analysis. Address me by name (\(firstname + " " + last_name)) in a friendly response with risk level, potential interactions, recommendations, and confidence score.
        """
