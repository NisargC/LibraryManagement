# README
Library Management System

Admin login credentials:
* Email: admin@admin.com
* Password: admin

Library Management System is deployed on the following configurations :
* Ruby version - 2.6.3p62

* Rails version - Rails 5.2.3

* Database used - MySQLite

* Deployed on - Amazon AWS EC2 
   System has following specifications :
      * Operating System - Amazon Linux 2 AMI (HVM)
      * RAM - 1GB
      * Disk Capacity - 30GB

Assumptions and implemented behaviour:
* There is only one admin in the system. You cannot create a new admin.
* Some html features like date picker don't work on safari/IE. Testing should be done on chrome.
* Admin can only edit his name, not his email or password as a change in these attributes might not allow other reviewers to access admin account.
* A librarian and a student cannot have the same email id. Neither can 2 students or 2 librarians.
* To create multiple books of the same ISBN, increase count while creating the book. Creating another set of books with same ISBN and different attributes is not allowed as ISBN is unique.
* An admin can do all operation that a librarian can do (for all libraries) and all the operations a student can do.
* A librarian can only view features for his/her own library.
* A student's operations are limited to his university. For example, he can view books from all libraries in his university.
* A student account cannot be deleted if he has books checked out or has pending dues. 
* A book cannot be deleted if it's checked out by anyone.
* If a student checks out a special collection book, his request will have to be approved by a librarian or the admin. If the book is available, the student will get the book. If he has already borrowed maximum books that he can or if the book is unavailable, the book will be added to his hold requests.
* A library cannot be deleted if any of it's books is checked out.