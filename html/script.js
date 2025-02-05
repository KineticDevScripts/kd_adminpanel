let playerSettings = {};
let selectedPlayerId = null; // Store the selected player's ID
let selectedResource = null; // Store the selected resource's Name

// Handle messages from Lua
window.addEventListener("message", (event) => {
  const data = event.data;

  if (data.action === "showMenu") {
    document.getElementById("menu-container").style.display = "flex";
  } else if (data.action === "hideMenu") {
    document.getElementById("menu-container").style.display = "none";
  } else if (data.action === "applySettings") {
    applySettings(data.settings);
  } else if (data.action === "updatePlayerList") {
    updatePlayerTable(data.players);
  } else if (data.action === "updateResourceList") {
    updateResourceTable(data.resources);
  } else if (data.action === "updatePlayerCount") {
    const playerCount = data.playerCount;
    document.getElementById('final-option-player-count').textContent = `Total Players: ${playerCount}`;
  } else if (data.action === "getServerData") {
    const data = data.data;
    document.getElementById('server-status').innerText = data.status;
    document.getElementById('player-count').innerText = data.playerCount + ' Players';
    document.getElementById('server-uptime').innerText = data.uptime;
    document.getElementById('server-version').innerText = data.version;
  }  else if (data.action === "updateLogs") {
    const log = data.log;
        const tableBody = document.getElementById('logs-table-body');

        // Create a new table row
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${log.timestamp}</td>
            <td>${log.action}</td>
            <td>${log.admin}</td>
            <td>${log.target}</td>
            <td>${log.details}</td>
        `;
        tableBody.appendChild(row); // Add the new row to the table
  }
});

// Close UI When Esc Key Pressed
document.addEventListener("keydown", function (event) {
  if (event.key === "Escape") {
      fetch(`https://${GetParentResourceName()}/closeMenu`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({})
      });
  }
});

function openTab(tabId) {
  const tabs = document.querySelectorAll(".tab");
  tabs.forEach((tab) => tab.classList.remove("active"));
  document.getElementById(tabId).classList.add("active");

  if (tabId === "players") {
    fetchPlayers();
  }

  if (tabId === "resources") {
    fetchResources();
  }

  if (tabId === 'server-data') {
    updateServerData();  
  }
}

function updateServerData() {
  // Send request to Lua to get real-time server data
  fetchServerData();
}

function fetchServerData() {
  // Trigger NUI message to fetch server data
  fetch(`https://${GetParentResourceName()}/getServerData`, {
    method: 'POST',
    body: JSON.stringify({ action: 'getServerData' })
  }).then(response => response.json()).then(data => {
    // Update server data in the UI
    document.getElementById('server-status').innerText = data.status;
    document.getElementById('player-count').innerText = data.playerCount + ' Players';
    document.getElementById('server-uptime').innerText = data.uptime;
    document.getElementById('server-version').innerText = data.version;
  }).catch(err => {
    console.error('Error fetching server data:', err);
  });
}

function selfRevive() {
  fetch(`https://${GetParentResourceName()}/selfRevive`, { method: "POST" });
}

function selfHeal() {
  fetch(`https://${GetParentResourceName()}/selfHeal`, { method: "POST" });
}

document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("resourceSearch");
    const resourceTableBody = document.querySelector("#resources-table tbody");

    if (!searchInput || !resourceTableBody) {
        console.error("Search input or resource table body not found.");
        return;
    }

    // Function to filter resources
    function filterResources() {
        const query = searchInput.value.toLowerCase();
        const rows = resourceTableBody.querySelectorAll("tr");

        rows.forEach(row => {
            const resourceName = row.querySelector(".resources-name").textContent.toLowerCase();
            const resourceState = row.querySelector(".resources-state").textContent.toLowerCase();
            if (resourceName.includes(query)) {
                row.style.display = "";
            } else if (resourceState.includes(query)) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        });
    }

    // Listen for input changes
    searchInput.addEventListener("input", filterResources);
    updateServerData();
});


function fetchPlayers() {
  fetch("https://kd_adminpanel/requestPlayers", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({})
  });
}

function fetchResources() {
  fetch("https://kd_adminpanel/requestResources", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({})
  });
}

function updatePlayerTable(players) {
  let tableBody = document.querySelector("#online-table tbody");
  tableBody.innerHTML = "";
  
  players.forEach(player => {
      let row = document.createElement("tr");
      row.classList.add("table-row-online");

      row.style.background = playerSettings.primaryColor; 
      row.style.border = `3px solid ${playerSettings.secondaryColor}`;
      row.style.boxShadow = `0px 0px 10px ${playerSettings.secondaryColor}`;

      row.innerHTML = `
          <td class="online-avatar">
              <img src="https://r2.fivemanage.com/KQGRRm8DukQthtgazMChN/images/kinetic-3.jpg" style="width: 50px; height: auto;" class="player-avatar">
          </td>
          <td class="online-name">${player.name}</td>
          <td class="online-id">${player.id}</td>
      `;
      row.addEventListener("click", function() {
          selectPlayer(player.id, player.name);
      });
      tableBody.appendChild(row);
  });
}

function updateResourceTable(resources) {
  let tableBody = document.querySelector("#resources-table tbody");
  tableBody.innerHTML = "";
  
  resources.forEach(resource => {
      let row = document.createElement("tr");
      row.classList.add("table-row-resources");

      row.style.background = playerSettings.primaryColor; 
      row.style.border = `3px solid ${playerSettings.secondaryColor}`;
      row.style.boxShadow = `0px 0px 10px ${playerSettings.secondaryColor}`;

      row.innerHTML = `
          <td class="resources-name">${resource.name}</td>
          <td class="resources-state">${resource.state}</td>
      `;
      row.addEventListener("click", function() {
          selectResource(resource.name, resource.state);
      });
      tableBody.appendChild(row);
  });
}

function selectPlayer(playerId, playerName) {
  openQuickActionsMenu(playerId, playerName)
}

function selectResource(resourceName, resourceState) {
  openManageResourceMenu(resourceName, resourceState)
}

// Function to open the quick actions menu with the selected player's info
function openQuickActionsMenu(playerId, playerName) {
  selectedPlayerId = playerId;
  document.getElementById('selected-player-name').textContent = `Selected Player: ${playerName}`;
  document.getElementById('quick-actions-menu').style.display = 'block';
}

function openManageResourceMenu(resourceName, resourceState) {
  selectedResource = resourceName;
  document.getElementById('selected-resource-name').textContent = `Selected Resource: ${resourceName}`;
  document.getElementById('manage-resource-menu').style.display = 'block';
}

function closeManageResourceMenu() {
  document.getElementById('manage-resource-menu').style.display = 'none';
}

function restartResource() {
  if (selectedResource) {
    fetch(`https://${GetParentResourceName()}/restartResource`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ resource: selectedResource })
    });
  }
  closeManageResourceMenu();
  fetchResources()
}

function startResource() {
  if (selectedResource) {
    fetch(`https://${GetParentResourceName()}/startResource`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ resource: selectedResource })
    });
  }
  closeManageResourceMenu();
  fetchResources()
}

function stopResource() {
  if (selectedResource) {
    fetch(`https://${GetParentResourceName()}/stopResource`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ resource: selectedResource })
    });
  }
  closeManageResourceMenu();
  fetchResources()
}

// Close the quick actions menu
function closeQuickActionsMenu() {
  document.getElementById('quick-actions-menu').style.display = 'none';
}

function banPlayer() {
  if (selectedPlayerId) {
      console.log(`Banning player with ID: ${selectedPlayerId}`);
      // Implement ban logic here (e.g., send to server)
  }
  closeQuickActionsMenu();
}

function gotoPlayer() {
  if (selectedPlayerId) {
      console.log(`Teleporting to player with ID: ${selectedPlayerId}`);
      
      fetch(`https://${GetParentResourceName()}/gotoPlayer`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ playerId: selectedPlayerId })
      });
  }
  closeQuickActionsMenu();
}

function revivePlayer() {
  if (selectedPlayerId) {
      console.log(`Revivng player with ID: ${selectedPlayerId}`);

      fetch(`https://${GetParentResourceName()}/revivePlayer`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ playerId: selectedPlayerId })
      });
  }
  closeQuickActionsMenu();
}

function healPlayer() {
  if (selectedPlayerId) {
      console.log(`Healing player with ID: ${selectedPlayerId}`);
      
      fetch(`https://${GetParentResourceName()}/healPlayer`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ playerId: selectedPlayerId })
      });
  }
  closeQuickActionsMenu();
}

function openSelfMoneyDialog() {
  document.getElementById("dialog").classList.add("active");
}

function closeSelfMoneyDialog() {
  document.getElementById("dialog").classList.remove("active");
}

function openItemDialog() {
  document.getElementById("item-dialog").classList.add("active");
}

function closeItemDialog() {
  document.getElementById("item-dialog").classList.remove("active");
}

function openKickDialog() {
  document.getElementById("kick-dialog").classList.add("active");
}

function closeKickDialog() {
  document.getElementById("kick-dialog").classList.remove("active");
}

function openSpawnCarDialog() {
  document.getElementById("spawn-car-dialog").classList.add("active");
}

function closeSpawnCarDialog() {
  document.getElementById("spawn-car-dialog").classList.remove("active");
}

function confirmAmount() {
  let amount = document.getElementById("itemAmount").value;
  amount = parseInt(amount, 10);
  
  if (!amount || amount < 1) {
      alert("Please enter a valid amount!");
      return;
  }

  // Trigger a FiveM event (replace 'yourEventName' with your actual event)
  fetch(`https://${GetParentResourceName()}/giveSelfMoney`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ amount: amount })
  });

  closeSelfMoneyDialog();
}

function confirmItem() {
  let item = document.getElementById("itemName").value;
  let amount = document.getElementById("itemQuantity").value;
  amount = parseInt(amount, 10);
  
  if (!amount || amount < 1) {
    alert("Please enter a valid amount!");
    return;
  }

  fetch(`https://${GetParentResourceName()}/givePlayerItem`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ playerId: selectedPlayerId, item: item, amount: amount })
  });

  closeItemDialog();
}

function confirmKick() {
  let reason = document.getElementById("kickReason").value.trim(); // Remove extra spaces

  if (reason.length === 0) {
    console.error("Kick reason is required.");
  } else {
    fetch(`https://${GetParentResourceName()}/kickPlayer`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ playerId: selectedPlayerId, reason: reason })
    });
  }

  closeKickDialog();
}

function confirmSpawnCar() {
  let model = document.getElementById("carModel").value.trim(); // Remove extra spaces

  if (model.length === 0) {
    console.error("Car model is required.");
  } else {
    fetch(`https://${GetParentResourceName()}/spawnCar`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ model: model })
    });
  }

  closeSpawnCarDialog();
}

function updatePrimaryColor(color) {
  document.querySelector(".sidebar").style.backgroundColor = color;
  document.querySelector(".close-button").style.backgroundColor = color;
  document.querySelector(".quick-actions-menu").style.backgroundColor = color;
  document.querySelector(".manage-resource-menu").style.backgroundColor = color;
  document.querySelector(".edit-pos-button").style.backgroundColor = color;
  document.querySelector(".save-pos-button").style.backgroundColor = color;
  document.querySelector(".dashboard-header").style.borderBottom = `6px solid ${color}`;
  document.querySelector(".server-data-header").style.borderBottom = `6px solid ${color}`;
  document.querySelector(".title-online").style.borderBottom = `6px solid ${color}`;
  document.querySelector(".resource-header").style.borderBottom = `6px solid ${color}`;
  document.querySelector(".title-logs").style.borderBottom = `6px solid ${color}`;
  document.querySelector(".settings-header").style.borderBottom = `6px solid ${color}`;
  document.querySelector(".dashboard-btn").style.backgroundColor = color;
    document.querySelector(".dashboard-btn2").style.backgroundColor = color;
    document.querySelector(".dashboard-btn3").style.backgroundColor = color;
    document.querySelector(".dashboard-btn4").style.backgroundColor = color;
    document.querySelector(".dashboard-btn5").style.backgroundColor = color;
    document.querySelector(".dashboard-btn6").style.backgroundColor = color;
    document.querySelector(".dashboard-btn7").style.backgroundColor = color;
    document.querySelector(".dashboard-btn8").style.backgroundColor = color;

  playerSettings.primaryColor = color;
  saveSettingsToServer();
}

function updateSecondaryColor(color) {
    document.querySelector(".sidebar-header").style.borderBottom = `6px solid ${color}`;
    document.querySelector(".menu").style.backgroundColor = color;
    document.querySelector(".dashboard").style.backgroundColor = color;
    document.querySelector(".server-data").style.backgroundColor = color;
    document.querySelector(".players").style.backgroundColor = color;
    document.querySelector(".resources").style.backgroundColor = color;
    document.querySelector(".logs").style.backgroundColor = color;
    document.querySelector(".settings").style.backgroundColor = color;
    document.querySelector(".pkick-btn").style.backgroundColor = color;
    document.querySelector(".pban-btn").style.backgroundColor = color;
    document.querySelector(".pgoto-btn").style.backgroundColor = color;
    document.querySelector(".previve-btn").style.backgroundColor = color;
    document.querySelector(".pheal-btn").style.backgroundColor = color;
    document.querySelector(".pgive-item-btn").style.backgroundColor = color;
    document.querySelector(".restart-btn").style.backgroundColor = color;
    document.querySelector(".start-btn").style.backgroundColor = color;
    document.querySelector(".stop-btn").style.backgroundColor = color;

    playerSettings.secondaryColor = color;
    saveSettingsToServer();
}

function updateMenuSize(size) {
  document.getElementById("menu-container").style.width = size + "%";
  document.getElementById("menu-container").style.height = size + "%";
  document.getElementById("menu-size").value = size;

  playerSettings.menuSize = size;
  saveSettingsToServer();
}

function enableDragMode() {
    const menu = document.getElementById("menu-container");
  
    menu.style.cursor = "move";
    menu.onmousedown = (e) => {
      const shiftX = e.clientX - menu.getBoundingClientRect().left;
      const shiftY = e.clientY - menu.getBoundingClientRect().top;
  
      function moveAt(pageX, pageY) {
        menu.style.left = pageX - shiftX + "px";
        menu.style.top = pageY - shiftY + "px";
      }
  
      function onMouseMove(event) {
        moveAt(event.pageX, event.pageY);
      }
  
      document.addEventListener("mousemove", onMouseMove);
  
      menu.onmouseup = () => {
        document.removeEventListener("mousemove", onMouseMove);
        menu.onmouseup = null;
  
        // Update the player settings with the new position
        const position = menu.getBoundingClientRect();
        playerSettings.menuPosition = { top: position.top, left: position.left };
  
        // Enable the "Save Position" button
        document.getElementById("save-position-btn").hidden = false;
      };
    };
  
    menu.ondragstart = () => false;
  }
  
  function savePosition() {
    const menu = document.getElementById("menu-container");
  
    // Disable dragging
    menu.style.cursor = "default";
    menu.onmousedown = null;
  
    // Save the new position to the server
    saveSettingsToServer();
  
    // Disable the "Save Position" button after saving
    document.getElementById("save-position-btn").hidden = true;
  }

function applySettings(settings) {
  playerSettings = settings;
  document.querySelector(".sidebar").style.backgroundColor = settings.primaryColor;
  document.querySelector(".sidebar-header").style.borderBottom = `6px solid ${settings.secondaryColor}`;
  document.querySelector(".dashboard-header").style.borderBottom = `6px solid ${settings.primaryColor}`;
  document.querySelector(".server-data-header").style.borderBottom = `6px solid ${settings.primaryColor}`;
  document.querySelector(".close-button").style.backgroundColor = settings.primaryColor;
  document.querySelector(".dashboard").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".server-data").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".players").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".resources").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".logs").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".settings").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".title-online").style.borderBottom = `6px solid ${settings.primaryColor}`;
  document.querySelector(".resource-header").style.borderBottom = `6px solid ${settings.primaryColor}`;
  document.querySelector(".title-logs").style.borderBottom = `6px solid ${settings.primaryColor}`;
  document.querySelector(".settings-header").style.borderBottom = `6px solid ${settings.primaryColor}`;

  document.querySelector(".dashboard-btn").style.backgroundColor = settings.primaryColor;
  document.querySelector(".dashboard-btn2").style.backgroundColor = settings.primaryColor;
  document.querySelector(".dashboard-btn3").style.backgroundColor = settings.primaryColor;
  document.querySelector(".dashboard-btn4").style.backgroundColor = settings.primaryColor;
  document.querySelector(".dashboard-btn5").style.backgroundColor = settings.primaryColor;
  document.querySelector(".dashboard-btn6").style.backgroundColor = settings.primaryColor;
  document.querySelector(".dashboard-btn7").style.backgroundColor = settings.primaryColor;
  document.querySelector(".dashboard-btn8").style.backgroundColor = settings.primaryColor;

  document.querySelector(".quick-actions-menu").style.backgroundColor = settings.primaryColor;
  document.querySelector(".pkick-btn").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".pban-btn").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".pgoto-btn").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".previve-btn").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".pheal-btn").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".pgive-item-btn").style.backgroundColor = settings.secondaryColor;

  document.querySelector(".manage-resource-menu").style.backgroundColor = settings.primaryColor;
  document.querySelector(".restart-btn").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".start-btn").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".stop-btn").style.backgroundColor = settings.secondaryColor;

  document.querySelector(".menu").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".edit-pos-button").style.backgroundColor = settings.primaryColor;
  document.querySelector(".save-pos-button").style.backgroundColor = settings.primaryColor;

  document.getElementById("menu-container").style.height = settings.menuSize + "%";
  document.getElementById("menu-container").style.width = settings.menuSize + "%";

  document.getElementById("menu-size").value = settings.menuSize;

  const menu = document.getElementById("menu-container");
  menu.style.top = settings.menuPosition.top + "px";
  menu.style.left = settings.menuPosition.left + "px";
}

function saveSettingsToServer() {
  fetch(`https://${GetParentResourceName()}/savePlayerSettings`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(playerSettings),
  });
}

function closeMenu() {
  fetch(`https://${GetParentResourceName()}/closeMenu`, { method: "POST" });
}