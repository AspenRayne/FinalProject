import { Recipe } from "./recipe";
import { User } from "./user";

export class Comment {

  id: number;
  commentDate: string;
  comment: string;
  user: User;
  recipe: Recipe;
  replyComment: Comment;
  comments: Comment[];

  constructor(

    id: number = 0,
    commentDate: string = '',
    comment: string = '',
    user: User = new User,
    recipe: Recipe = new Recipe,
    replyComment: Comment = new Comment,
    comments: Comment[] = []
  )
  {
    this.id = id;
    this.commentDate = commentDate;
    this.comment = comment;
    this.user = user;
    this.recipe = recipe;
    this.replyComment = replyComment;
    this.comments = comments


  }
}
