package com.skilldistillery.produce.entities;

import java.util.Objects;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Reaction {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	int id;
	char emoji;
	
	public Reaction() { }

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public char getEmoji() {
		return emoji;
	}

	public void setEmoji(char emoji) {
		this.emoji = emoji;
	}

	@Override
	public int hashCode() {
		return Objects.hash(emoji, id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Reaction other = (Reaction) obj;
		return emoji == other.emoji && id == other.id;
	}

	@Override
	public String toString() {
		return "Reaction [id=" + id + ", emoji=" + emoji + "]";
	}
	
	
}
