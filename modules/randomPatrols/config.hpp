/*
	framework de mission du CORP
	http://www.corp-arma.fr
*/

// activer ou désactiver le module
enabled = 1;

// si activé, la variable globale "CPR_var_randomPatrols_patrols" sera créée
// elle contiendra la liste des patrouilles (groupes) créés par le module
// la variable "CPR_var_randomPatrols_ready" vaut vrai une fois que le module a terminé de créer les patrouilles
return = 0;

// délais en secondes entre la création de deux patrouilles
// permet de réduire la charge serveur momentanée
pause = 5;

// informations sur les zones de patrouilles
// sides possibles : West, East, Indep
// les classnames des groupes se trouvent dans CfgGroups
class Patrols {
	class North {
		center[]	= {6000,7000,0};
		radius		= 65;
		side		= "East";

		groups[] = {
			{"East", "rhs_faction_vdv", "rhs_group_rus_vdv_infantry", "rhs_group_rus_vdv_infantry_chq"}, // groupe RHS
			{"West", "Guerilla", "Infantry", "IRG_InfSquad_Weapons"} // groupe FIA BLUFOR avec un side OPFOR
		};
	};

	class EastHouse {
		center[]	= {7721.21,7513.03,0};
		radius		= 75;
		side		= "Indep";

		groups[] = {
			{"Indep", "IND_C_F", "Infantry", "BanditCombatGroup"}
		};
	};
};
