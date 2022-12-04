package com.skilldistillery.produce.entities;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name="recipe_comment")
public class Comment {

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@Column(name="comment_date")
	private LocalDateTime commentDate;
	
	private String comment;
	
	@ManyToOne
	@JoinColumn(name="user_id")
	private User user;
	
	@JsonIgnore
	@ManyToOne
	@JoinColumn(name="recipe_id")
	private Recipe recipe;
	
	@JsonIgnore
	@ManyToOne
	@JoinColumn(name="in_reply_to")
	private Comment replyComment;
	
	@OneToMany(mappedBy="replyComment")
	private List<Comment> comments;
	
	public Comment() { }

	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public LocalDateTime getCommentDate() {
		return commentDate;
	}


	public void setCommentDate(LocalDateTime commentDate) {
		this.commentDate = commentDate;
	}


	public String getComment() {
		return comment;
	}


	public void setComment(String comment) {
		this.comment = comment;
	}
	
	public User getUser() {
		return user;
	}
	
	public void setUser(User user) {
		this.user = user;
	}

	public Recipe getRecipe() {
		return recipe;
	}

	public void setRecipe(Recipe recipe) {
		this.recipe = recipe;
	}

	public Comment getReplyComment() {
		return replyComment;
	}

	public void setReplyComment(Comment replyComment) {
		this.replyComment = replyComment;
	}

	public List<Comment> getComments() {
		return comments;
	}

	public void setComments(List<Comment> comments) {
		this.comments = comments;
	}
	public void addComment(Comment comment) {
		if (comments == null) {
			comments = new ArrayList<>();
		}
		if (!comments.contains(comment)) {
			comments.add(comment);
			if (comment.getReplyComment() != null) {
				comment.getReplyComment().getComments().remove(comment);
			}
			comment.setReplyComment(this);
		}
	}

	public void removeComment(Comment comment) {
		if (comments != null) {
			comments.remove(comment);
			comment.setReplyComment(null);
		}
	}
	@Override
	public int hashCode() {
		return Objects.hash(id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Comment other = (Comment) obj;
		return id == other.id;
	}


	@Override
	public String toString() {
		return "Comment [id=" + id + ", commentDate=" + commentDate + ", comment=" + comment + "]";
	}
	
	
	
}
