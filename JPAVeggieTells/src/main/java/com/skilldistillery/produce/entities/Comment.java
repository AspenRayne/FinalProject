package com.skilldistillery.produce.entities;

import java.time.LocalDateTime;
import java.util.Objects;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="recipe_comment")
public class Comment {

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	@Column(name="comment_date")
	private LocalDateTime commentDate;
	private String comment;
	
	
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
