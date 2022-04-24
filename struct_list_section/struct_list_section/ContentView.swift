//
//  ContentView.swift
//  struct_list_section
//
//  Created by Ananya Garg on 4/11/22.
//

import SwiftUI

struct Meal: Identifiable {
let name: String
    var foods: [Food]
var meal_cals: Int {
    var result: Int = 0
    for Food in foods {
        result += Food.calories
    }
    return result
}
let id = UUID()
}


struct ContentView: View {

@State private var add_food: Bool = false
@State private var show_Picker: Bool = false
@State private var date = Date()
@State private var edit_button: Bool = false
@State private var diary_done: Bool = false

private var goal_cals: Int = 2000
private var food_cals: Int = 1500
private var exercise_cals: Int = 150
    
var calories_eaten: Int {
        var result: Int = 0
        for meal in meals{
            for food in meal.foods{
                result += food.calories
            }
        }
        return result
    }
private var remaining_cals: Int {
    var leftover_cals: Int
    leftover_cals = goal_cals - calories_eaten + exercise_cals
    return leftover_cals
}


// make meal state property, append when new food added, // pass binding
@State private var meals: [Meal] = [
    Meal(name: "Breakfast",
         foods: [Food(name: "Greek Yogurt", company: "Dannon", amount: 1, calories: 150, unit: "cup"),
                 Food(name: "Granola", company: "Costco", amount: 1, calories: 200,  unit: "cup"),
                 Food(name: "Cheese", company: "Walmart", amount: 1, calories: 300,  unit: "cup")
                ]),
    Meal(name: "Lunch",
         foods: [Food(name: "Quarter Pounder", company: "McDonald's", amount: 1, calories: 200, unit: "burger"),
                 Food( name: "Fries", company: "McDonald's", amount: 1, calories: 300, unit: "small"),
                 Food(name: "Diet Coke", company: "Coca-Cola", amount: 1, calories: 0, unit: "Large")
         ]),
    Meal(name: "Dinner",
         foods: [Food(name: "NY Strip Steak", company: "Harris Teeter", amount: 1, calories: 450,  unit: "steak"),
                 Food(name: "Fries", company: "Tyson", amount: 3, calories: 300,  unit: "ounces")
         ]),
]





var body: some View {
    NavigationView{
        VStack{
            Divider()
            HStack(spacing: 180){
                Text("Calories Remaining")
                    .font(.system(size: 18, weight: .semibold))
                    .fontWeight(.semibold)
                Image(systemName: "ellipsis")
            }

            Spacer()
            HStack(spacing: 23.0){
                VStack{
                    Text(String(goal_cals))
                    Text("Goal")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text("-")
                VStack{
                    Text(String(calories_eaten))
                    Text("Food")
                        .font(.caption)

                }
                Text("+")
                VStack{
                    Text(String(exercise_cals))
                    Text("Exercise")
                        .font(.caption)

                }
                Text("=")
                VStack{
                    Text(String(remaining_cals))
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.blue)
                    Text("Remaining")
                        .font(.caption)
                }
                
                
                
            }
            .padding(.bottom)
            
            

        
        List(){
            ForEach($meals){ $meal in
                Section{
                    ForEach(meal.foods){ food in
                        HStack{
                            
                            VStack(alignment: .leading){
                                Text(food.name)
                                Text("\(food.company), \(food.amount) \(food.unit) ")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(String(food.calories))
                        }
                        
                        
                    }

                    
                    
                    NavigationLink(destination: {addBreakfast(meal: $meal)}
                                   ){
                        
                        Text("ADD FOOD")
                            .foregroundColor(.blue)
                            .font(.system(size: 18, weight: .bold))
                    }
                                   
                }
                header: {Text(meal.name)
                        .foregroundColor(.black)
                        .font(.system(size: 15, weight: .bold))
                    
                }
                
            }
        
        }
        .toolbar{
            ToolbarItem(placement: .navigation){
                Button("Edit"){
                    edit_button.toggle()
                }
                Spacer().frame(width: 200.0)
            }
            ToolbarItem(placement: .principal){
                DatePicker(
                "Today",
                selection: $date,
                displayedComponents: [.date]
                )

                    .labelsHidden()
            }
            ToolbarItem(placement: .automatic){
                Button {
                    
                    
                    diary_done.toggle()
                    
                    
                    
                } label: {
                    Image(systemName: "checkmark.rectangle.portrait.fill")
            }
        }
            


            }

        }
        
        }
        .listStyle(.grouped)
        
    }
}


struct Food: Identifiable {

var name: String
var company: String
var amount: Int
var calories: Int
var unit: String
let id = UUID()

}

struct quickAccesses: Identifiable{
var image: Image
var caption: String
let id = UUID()
}

struct circle_plus: View{
    var body: some View{
        Circle()
            .frame(width: 35, height: 35)
            .foregroundColor(Color.gray.opacity(0.14))
            .overlay{
                Image(systemName: "plus")
                    .frame(width: 20, height: 20)
                    .opacity(3.0)
                    .foregroundColor(.blue)
                
            }

            
            
    }
}
struct check_plus: View{
    var body: some View{
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.blue)
    }
}
    
struct add_button_view: View{
    
    let action:() -> Void
    var is_added: Bool
    
    var animation_amount: Int = 2
    
    
    var body: some View{
        Button(action: action, label: {
            if is_added == true{
                check_plus()
            }
            else{
                circle_plus()
            }
            
        })
            .animation(.easeIn, value: animation_amount
            )
            .padding()
    }
}

    
struct FoodView: View{
    @Binding var meal: Meal
    let food: Food
    // Temp Var:
    @State var add_food_button: Bool = true
    

var body: some View{

        RoundedRectangle(cornerRadius: 10)
            .frame(width: 360, height: 75)
            .foregroundColor(Color.gray.opacity(0.1))
            .overlay(
                HStack{
                    VStack(alignment: .leading){
                        Text(food.name)
                        Text("\(String(food.calories)) cal, \(food.amount) \(food.unit) \(food.company)")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    Spacer()
                    
                    add_button_view(action: {
                        meal.foods.append(food)
                        
                    }, is_added: meal.foods.contains(where: { selected_food in
                        food.id == selected_food.id
                    }))
                    

                }
            
            )
        
        

}
}
    
struct FoodHeader: View{
    @State var show_frequent: Bool = true
    var body: some View{
        
        Rectangle()
            .frame(height: 40)
            .foregroundColor(Color.white)
            .overlay{
                HStack{
                    Text("History").padding().font(.system(size: 19, weight: .medium))
                Spacer()
                RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    .frame(width: 160, height: 30)
                    .foregroundColor(Color.white)
                    .overlay{
                        HStack{
                            Image(systemName: "line.3.horizontal.decrease.circle")
                            Text("Most Frequent")
                        }
                        
                    }
                    .padding()
                }
                
            }
       
            
        
    }
}


    
    


struct addBreakfast: View{
    public init(meal: Binding<Meal>) {
    self._meal = meal
    }
    
    
    @Binding var meal: Meal
    @State private var add_foods_list: [Food] = [
        Food(name: "Marinara Sauce",
                company: "Homemade",
                amount: 1, calories: 100,
                unit: "cup"),
        Food(name: "Green Grapes",
                company: "Costco",
                amount: 1,
                calories: 60,
                unit: "oz"),
        Food(name: "Sandwich Bread",
                company: "Nature's Own",
                amount: 2, calories: 70,
                unit: "slices"),
        Food(name: "Cooca Puffs", company: "Kellog's", amount: 1, calories: 133, unit: "cup"),
        Food(name: "Skim Milk", company: "Fairlife", amount: 1, calories: 80, unit: "cup"),
        Food(name: "Marinara Sauce",
                company: "Homemade",
                amount: 1, calories: 100,
                unit: "cup"),
        Food(name: "Green Grapes",
                company: "Costco",
                amount: 1,
                calories: 60,
                unit: "oz"),
        Food(name: "Sandwich Bread",
                company: "Nature's Own",
                amount: 2, calories: 70,
                unit: "slices"),
        Food(name: "Cooca Puffs", company: "Kellog's", amount: 1, calories: 133, unit: "cup"),
        Food(name: "Marinara Sauce",
                company: "Homemade",
                amount: 1, calories: 100,
                unit: "cup"),
        Food(name: "Green Grapes",
                company: "Costco",
                amount: 1,
                calories: 60,
                unit: "oz"),
        Food(name: "Sandwich Bread",
                company: "Nature's Own",
                amount: 2, calories: 70,
                unit: "slices"),
        Food(name: "Cooca Puffs", company: "Kellog's", amount: 1, calories: 133, unit: "cup")
        
    ]
    
    private var easy_access_list: [quickAccesses] = [
        
        quickAccesses(image: Image(systemName: "viewfinder"), caption: "Scan a meal"),
        quickAccesses(image: Image(systemName: "barcode.viewfinder"), caption: "Scan a barcode"),
        quickAccesses(image: Image(systemName: "flame"), caption: "Quick Add")
    ]
    



    
    var body: some View{
        VStack{
            
            Spacer()
            
                HStack(alignment: .center, spacing: 30){
                    Text("All")
                        .font(.system(size: 18, weight: .bold))
                    Text("My Meals")
                        .font(.system(size: 18))
                    Text("My Recipes")
                        .font(.system(size: 18))
                    Text("My Foods")
                        .font(.system(size: 18))
                    
                }

                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 10){
                        ForEach(easy_access_list, id: \.id){
                            rectangle in
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white)
                                    .frame(width: 180, height: 120)
                                VStack{
                                    rectangle.image
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(.blue)
                                    Text(rectangle.caption)
                                        .foregroundColor(.blue)
                                        .font(.system(size: 20))
                                        
                                }
                                
                            }

                        }
                        
                    }.padding()
                }.frame(height: 160).background(Color.blue.opacity(0.15).edgesIgnoringSafeArea(.all))
                
                Spacer()
               
            Section(header: FoodHeader()){
                    ScrollView(){
                        ForEach(add_foods_list, id: \.id){
                            food in
                            FoodView(meal: $meal, food: food)
                            
                        }
                    }
                    
                }
                 
                
            
            
        }
        .navigationTitle(meal.name)
        .navigationBarTitleDisplayMode(.inline)
        
        
            
        
            }
        
        }
    
        
    



struct ContentView_Previews: PreviewProvider {
static var previews: some View {
    ContentView()
}
}

