class CheckoutDoneMailer < ApplicationMailer
  def checkout_hold(studentUser, user, book)
    @user = user
    @book = book
    @studentUser = studentUser
    mail(to: @studentUser.email, subject: @book.title + ' checkout successful!')
  end

  def checkout_done(studentUser, user, book)
    @user = user
    @book = book
    @studentUser = studentUser
    mail(to: @studentUser.email, subject: @book.title + ' checkout successful!')
  end

  def checkout_special(studentUser, user, book)
    @user = user
    @book = book
    @studentUser = studentUser
    mail(to: @studentUser.email, subject: @book.title + ' checkout successful!')
  end
end
