/*
	cette fonction ne devrait jamais être utilisée directement
	utilisez CRP_fnc_addTask et CRP_fnc_setTaskState
*/

params [
	"_mode",
	"_params"
];

switch (_mode) do
{
	// si on doit ajouter la tâche
	case "ADD": {
		// on extrait les paramètres
		_ref	= _params select 0;
		_title	= _params select 1;
		_desc	= _params select 2;
		_notif	= _params select 3;

		// si je suis le serveur, on demande aux joueurs d'exécuter cette fonction, même pour les JIP
		if (isDedicated) then {
			// todo, gérer les demandes de créations de taches déjà existantes avec un tableau côté serveur
			["ADD", [_ref, _title, _desc, _notif]] remoteExec ["CRP_fnc_taskProceed", X_remote_client, true];
		};

		// si je suis un joueur
		if (!isDedicated) then {
			// si le tableau des tâches n'existe pas, je le créé
			if (isNil {CRP_var_tasks}) then {
				CRP_var_tasks = [];
			};

			// si la tâche n'éxiste pas déjà
			if (isNil {[CRP_var_tasks, _ref] call BIS_fnc_getFromPairs}) then {
				// je créé la tâche et la sauvegarde dans le tableau des tâches
				_task = player createSimpleTask [_ref];
				[CRP_var_tasks, _ref, [_task, _title]] call BIS_fnc_setToPairs;

				// on décrit la tâche
				_task setSimpleTaskDescription [_desc, _title, ""];

				// on affiche la notification si demandé
				if (_notif) then {
					["TaskCreated", ["", _title]] call BIS_fnc_showNotification;
				};
			};
		};
	};

	// si on doit définir son état
	case "SET": {
		// on extrait les paramètres
		_ref	= _params select 0;
		_state	= _params select 1;
		_notif	= _params select 2;
		_text	= _params select 3;

		// si je suis le serveur, je demande aux joueurs d'exécuter cette fonction, même pour les JIP
		if (isDedicated) then {
			// todo gérer les demande sur tes tâches qui n'existent pas avec un tableau côté serveur
			["SET", [_ref, _state, _notif, _text]] remoteExec ["CRP_fnc_taskProceed", X_remote_client, true];
		};

		// sinon, si je suis un joueur
		if (!isDedicated) then {
			[_ref, _state, _notif, _text] spawn {
				_ref	= _this select 0;
				_state	= _this select 1;
				_notif	= _this select 2;
				_text	= _this select 3;

				// on s'assure que la tâche a été créée
				waitUntil {!isNil {[CRP_var_tasks, _ref] call BIS_fnc_getFromPairs}};

				// récupération de la tâche
				_task = [CRP_var_tasks, _ref] call BIS_fnc_getFromPairs;

				// modifie l'état de la tâche
				(_task select 0) setTaskState _state;

				// on affiche la notification si demandé
				if (_notif) then {
					// si on text spécifique est passé, on l'utilise
					// sinon on utilise le titre de la tâche
					if ((typeName _text) == "BOOL") then {
						_text = _task select 1;
					};

					// affichage de la notification
					[format ["Task%1", _state], ["", _text]] call BIS_fnc_showNotification;
				};
			};
		};
	};
};