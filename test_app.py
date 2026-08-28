"""Tests unitaires pour velos-api. Tournent sans base de donnees :
ils utilisent le jeu de secours en memoire (aucune variable DATABASE_URL definie)."""
from app import app


def test_stations_renvoie_le_jeu_de_secours():
    client = app.test_client()
    reponse = client.get("/stations")
    donnees = reponse.get_json()
    assert reponse.status_code == 200
    assert donnees["source"] == "memoire"
    assert len(donnees["stations"]) > 0


def test_alertes_renvoie_seulement_les_stations_sous_le_seuil():
    client = app.test_client()
    reponse = client.get("/alertes")
    donnees = reponse.get_json()
    assert reponse.status_code == 200
    assert donnees["source"] == "memoire"
    for station in donnees["stations"]:
        assert station["velos_disponibles"] <= 2
