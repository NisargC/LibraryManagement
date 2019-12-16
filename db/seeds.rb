# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!( :id=> 1,  :email=> 'admin@admin.com',  :name=> 'Admin' ,  :password=> 'YWRtaW4=' ,  :role=> '0' , :request=> '0' )
Student.create!( :id=>1, :user_id=> 1, :max_books=> 1000000 , :borrow_count=> 0 , :dues=> 0, :university=>'None', :education_level=>'None')
Librarian.create!(:id=> 1,:user_id=> 1, :library_id=>0)
Library.create!( :id=> 1, :name=> 'Hunt', :university=> 'NC State', :location=> 'Raleigh',  :max_days=> 5,  :overdue_fines=> 10)
Library.create!( :id=> 2, :name=> 'Hill', :university=> 'NC State', :location=> 'Raleigh',  :max_days=> 7,  :overdue_fines=> 5)
Library.create!( :id=> 3, :name=> 'Chapel Library', :university=> 'UNCC', :location=> 'Chapel Hill',  :max_days=> 10,  :overdue_fines=> 15)
Library.create!( :id=> 4, :name=> 'Duke Library', :university=> 'Duke', :location=> 'Durham',  :max_days=> 15,  :overdue_fines=> 20)