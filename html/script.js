let playerSettings = {};
let selectedPlayerId = null;
let selectedResource = null; 

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
  } else if (data.action === "getServerData") {
    const data = data.data;
    document.getElementById('resource-count').innerText = data.resourceCount;
    document.getElementById('player-count').innerText = data.playerCount + ' Players';
    document.getElementById('server-uptime').innerText = data.uptime;
    document.getElementById('server-version').innerText = data.version;
  }  else if (data.action === "updateLogs") {
    const log = data.log;
        const tableBody = document.getElementById('logs-table-body');

        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${log.timestamp}</td>
            <td>${log.action}</td>
            <td>${log.admin}</td>
            <td>${log.target}</td>
            <td>${log.details}</td>
        `;
        tableBody.appendChild(row); 
  }
});

document.addEventListener("keydown", function (event) {
  if (event.key === "Escape") {
      closeMenu()
  }
});

document.addEventListener("DOMContentLoaded", function () {
  const searchInput = document.getElementById("resourceSearch");
  const resourceTableBody = document.querySelector("#resources-table tbody");

  if (!searchInput || !resourceTableBody) {
      console.error("Search input or resource table body not found.");
      return;
  }

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

  searchInput.addEventListener("input", filterResources);
  updateServerData();
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

// Dashboard tab
function updateServerData() {
  fetchServerData();
}

function fetchServerData() {
  fetch(`https://${GetParentResourceName()}/getServerData`, {
    method: 'POST',
    body: JSON.stringify({ action: 'getServerData' })
  }).then(response => response.json()).then(data => {
    document.getElementById('resource-count').innerText = data.resourceCount;
    document.getElementById('player-count').innerText = data.playerCount + ' Players';
    document.getElementById('server-uptime').innerText = data.uptime;
    document.getElementById('server-version').innerText = data.version;
  }).catch(err => {
    console.error('Error fetching server data:', err);
  });
}

// End Dashboard tab

// Admin Actions tab
function openSelfMoneyDialog() {
  document.getElementById("dialog").classList.add("active");
}

function closeSelfMoneyDialog() {
  document.getElementById("dialog").classList.remove("active");
}

function openSelfItemDialog() {
  document.getElementById("self-item-dialog").classList.add("active");
}

function closeSelfItemDialog() {
  document.getElementById("self-item-dialog").classList.remove("active");
}

function openSpawnCarDialog() {
  document.getElementById("spawn-car-dialog").classList.add("active");
}

function closeSpawnCarDialog() {
  document.getElementById("spawn-car-dialog").classList.remove("active");
}

function unbanDialog() {
  document.getElementById("unban-dialog").classList.add("active");
}

function closeUnbanDialog() {
  document.getElementById("unban-dialog").classList.remove("active");
}

function announcementDialog() {
  document.getElementById("announcement-dialog").classList.add("active");
}

function closeAnnouncementDialog() {
  document.getElementById("announcement-dialog").classList.remove("active");
}

function coordsDialog() {
  document.getElementById("coords-dialog").classList.add("active");
}

function closeCoordsDialog() {
  document.getElementById("coords-dialog").classList.remove("active");
}

function tpCoordsDialog() {
  document.getElementById("tpCoords-dialog").classList.add("active");
}

function closeTpDialog() {
  document.getElementById("tpCoords-dialog").classList.remove("active");
}

function selfRevive() {
  fetch(`https://${GetParentResourceName()}/selfRevive`, { method: "POST" });
}

function selfHeal() {
  fetch(`https://${GetParentResourceName()}/selfHeal`, { method: "POST" });
}

function confirmAmount() {
  let account = document.getElementById("accountType").value;
  let amount = document.getElementById("itemAmount").value;
  amount = parseInt(amount, 10);
  
  if (!amount || amount < 1) {
      alert("Please enter a valid amount!");
      return;
  }

  fetch(`https://${GetParentResourceName()}/giveSelfMoney`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ amount: amount, account: account })
  });

  closeSelfMoneyDialog();
}

function confirmSelfItem() {
  let item = document.getElementById("selfItemName").value;
  let amount = document.getElementById("selfItemQuantity").value;
  amount = parseInt(amount, 10);
  
  if (!amount || amount < 1) {
    alert("Please enter a valid amount!");
    return;
  }

  fetch(`https://${GetParentResourceName()}/giveSelfItem`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ item: item, amount: amount })
  });

  closeSelfItemDialog();
}

function toggleNoClip() {
  fetch(`https://${GetParentResourceName()}/toggleNoClip`, { method: "POST" });
  
  // setTimeout(() => {
  //   closeMenu();
  // }, 500); 
}

function toggleInvisibility() {
  fetch(`https://${GetParentResourceName()}/toggleInvisibility`, { method: "POST" });
}

function toggleGodMode() {
  fetch(`https://${GetParentResourceName()}/toggleGodMode`, { method: "POST" });
}

function confirmSpawnCar() {
  let model = document.getElementById("carModel").value.trim(); 

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

function deleteVehicle() {
  fetch("https://kd_adminpanel/deleteVehicle", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({})
  }); 
}

function repairVehicle() {
  fetch(`https://${GetParentResourceName()}/repairVehicle`, { method: "POST" });
}

function confirmUnban() {
  let license = document.getElementById("license").value;

  if (license.length === 0) {
    console.error("Player license is required.");
  } else {
    fetch(`https://${GetParentResourceName()}/unbanPlayer`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ license: license })
    });
  }

  closeUnbanDialog();
}

function confirmAnnouncement() {
  let msg = document.getElementById("announcement").value;

  if (msg.length === 0) {
    console.error("Announcement message is required.");
  } else {
    fetch(`https://${GetParentResourceName()}/announcement`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ msg: msg })
    });
  }

  closeAnnouncementDialog();
}

function deleteVehicles() {
  fetch("https://kd_adminpanel/deleteVehicles", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({})
  }); 
}

function deleteObjects() {
  fetch("https://kd_adminpanel/deleteObjects", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({})
  });
}

function deletePeds() {
  fetch("https://kd_adminpanel/deletePeds", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({})
  });
}

function confirmCoords() {
  let type = document.getElementById("coordsType").value;
  
  if (type.length === 0) {
      alert("Please select a valid type!");
      return;
  }

  fetch(`https://${GetParentResourceName()}/copyCoords`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ type: type })
  });

  closeCoordsDialog();
}

function confirmTp() {
  const input = document.getElementById("tp_vec3").value.trim();
  const coords = input.split(",").map(num => parseFloat(num.trim()));

  if (coords.length === 3 && coords.every(num => !isNaN(num))) {
      fetch(`https://${GetParentResourceName()}/tpToCoords`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ coords: coords })
      });
      closeTpDialog();
  } else {
      alert("Invalid format! Use: x, y, z (e.g., 200.0, 300.0, 50.0)");
  }
}

// End Admin Actions tab

// Players Tab
function fetchPlayers() {
  fetch("https://kd_adminpanel/requestPlayers", {
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

function selectPlayer(playerId, playerName) {
  openQuickActionsMenu(playerId, playerName)
}

function openQuickActionsMenu(playerId, playerName) {
  selectedPlayerId = playerId;
  document.getElementById('selected-player-name').textContent = `Selected Player: ${playerName}`;
  document.getElementById('quick-actions-menu').style.display = 'block';
}

function closeQuickActionsMenu() {
  document.getElementById('quick-actions-menu').style.display = 'none';
}

function openKickDialog() {
  document.getElementById("kick-dialog").classList.add("active");
}

function closeKickDialog() {
  document.getElementById("kick-dialog").classList.remove("active");
}

function openBanDialog() {
  document.getElementById("ban-dialog").classList.add("active");
}

function closeBanDialog() {
  document.getElementById("ban-dialog").classList.remove("active");
}

function openItemDialog() {
  document.getElementById("item-dialog").classList.add("active");
}

function closeItemDialog() {
  document.getElementById("item-dialog").classList.remove("active");
}

function openPMoneyDialog() {
  document.getElementById("pMoney-dialog").classList.add("active");
}

function closePMoneyDialog() {
  document.getElementById("pMoney-dialog").classList.remove("active");
}

function confirmKick() {
  if (selectedPlayerId) {
    let reason = document.getElementById("kickReason").value.trim(); 

    if (reason.length === 0) {
      console.error("Kick reason is required.");
    } else {
      fetch(`https://${GetParentResourceName()}/kickPlayer`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ playerId: selectedPlayerId, reason: reason })
      });
    }
  }
  closeKickDialog();
}

function confirmBan() {
  if (selectedPlayerId) {
    let reason = document.getElementById("banReason").value.trim(); 
    let time = document.getElementById("banTime").value;
  
    if (reason.length === 0) {
      console.error("Ban reason is required.");
    } else if (time.lenth === 0) {
      console.error("Ban time is required.");
    } else {
      fetch(`https://${GetParentResourceName()}/banPlayer`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ playerId: selectedPlayerId, reason: reason, time: time })
      });
    }
  }
  closeBanDialog();
}

function gotoPlayer() {
  if (selectedPlayerId) {
    fetch(`https://${GetParentResourceName()}/gotoPlayer`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ playerId: selectedPlayerId })
    });
  }
  closeQuickActionsMenu();
}

function bringPlayer() {
  if (selectedPlayerId) {
    fetch(`https://${GetParentResourceName()}/bringPlayer`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ playerId: selectedPlayerId })
    });
  }
  closeQuickActionsMenu();
}

function revivePlayer() {
  if (selectedPlayerId) {
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
    fetch(`https://${GetParentResourceName()}/healPlayer`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ playerId: selectedPlayerId })
    });
  }
  closeQuickActionsMenu();
}

function confirmItem() {
  if (selectedPlayerId) {
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
  }
  closeItemDialog();
}

function confirmPMoney() {
  if (selectedPlayerId) {
    let account = document.getElementById("pAccountType").value;
    let amount = document.getElementById("pAmount").value;
    amount = parseInt(amount, 10);
    
    if (!amount || amount < 1) {
        alert("Please enter a valid amount!");
        return;
    }
  
    fetch(`https://${GetParentResourceName()}/givePlayerMoney`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ playerId: selectedPlayerId, account: account, amount: amount })
    });
  }
  closePMoneyDialog();
}

// End Players tab

// Resources tab
function fetchResources() {
  fetch("https://kd_adminpanel/requestResources", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({})
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

function selectResource(resourceName, resourceState) {
  openManageResourceMenu(resourceName, resourceState)
}

function openManageResourceMenu(resourceName, resourceState) {
  selectedResource = resourceName;
  document.getElementById('selected-resource-name').textContent = `Selected Resource: ${resourceName} | ${resourceState}`;
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

// End Resources tab

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

  document.querySelectorAll("[class^='dashboard-btn']").forEach(btn => {
    btn.style.background = color;
  });

  document.querySelector(".table-row-online").style.background = color;
  document.querySelector(".table-row-resources").style.background = color;

  playerSettings.primaryColor = color;
  saveSettingsToServer();
}

function updateSecondaryColor(color) {
    document.querySelector(".sidebar-header").style.borderBottom = `6px solid ${color}`;
    document.querySelector(".menu").style.backgroundColor = color;
    document.querySelector(".dashboardB").style.backgroundColor = color;
    document.querySelector(".server-data").style.backgroundColor = color;
    document.querySelector(".players").style.backgroundColor = color;
    document.querySelector(".resources").style.backgroundColor = color;
    document.querySelector(".logs").style.backgroundColor = color;
    document.querySelector(".settings").style.backgroundColor = color;
    document.querySelectorAll("[class^='quick-actions-btn']").forEach(btn => {
      btn.style.background = color;
    });
    document.querySelector(".restart-btn").style.backgroundColor = color;
    document.querySelector(".start-btn").style.backgroundColor = color;
    document.querySelector(".stop-btn").style.backgroundColor = color;

    document.querySelectorAll("[class^='dashboard-btn']").forEach(btn => {
      btn.style.border = `3px solid ${color}`;
      btn.style.boxShadow = `0px 0px 10px ${color}`;
    });

    document.querySelector(".edit-pos-button").style.border = `3px solid ${color}`;
    document.querySelector(".edit-pos-button").style.boxShadow = `0px 0px 10px ${color}`;

    document.querySelector(".save-pos-button").style.border = `3px solid ${color}`;
    document.querySelector(".save-pos-button").style.boxShadow = `0px 0px 10px ${color}`;

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
  document.querySelector(".dashboardB").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".server-data").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".players").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".resources").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".logs").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".settings").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".title-online").style.borderBottom = `6px solid ${settings.primaryColor}`;
  document.querySelector(".resource-header").style.borderBottom = `6px solid ${settings.primaryColor}`;
  document.querySelector(".title-logs").style.borderBottom = `6px solid ${settings.primaryColor}`;
  document.querySelector(".settings-header").style.borderBottom = `6px solid ${settings.primaryColor}`;
  document.querySelector(".table-row-online").style.background = settings.primaryColor;
  document.querySelector(".table-row-resources").style.background = settings.primaryColor;

  document.querySelectorAll("[class^='dashboard-btn']").forEach(btn => {
    btn.style.background = settings.primaryColor;
    btn.style.border = `3px solid ${settings.secondaryColor}`;
    btn.style.boxShadow = `0px 0px 10px ${settings.secondaryColor}`;
  });
  

  document.querySelector(".quick-actions-menu").style.backgroundColor = settings.primaryColor;
  document.querySelectorAll("[class^='quick-actions-btn']").forEach(btn => {
    btn.style.background = settings.secondaryColor;
  });

  document.querySelector(".manage-resource-menu").style.backgroundColor = settings.primaryColor;
  document.querySelector(".restart-btn").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".start-btn").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".stop-btn").style.backgroundColor = settings.secondaryColor;

  document.querySelector(".menu").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".edit-pos-button").style.backgroundColor = settings.primaryColor;
  document.querySelector(".save-pos-button").style.backgroundColor = settings.primaryColor;

  document.querySelector(".edit-pos-button").style.border = `3px solid ${settings.secondaryColor}`;
  document.querySelector(".edit-pos-button").style.boxShadow = `0px 0px 10px ${settings.secondaryColor}`;

  document.querySelector(".save-pos-button").style.border = `3px solid ${settings.secondaryColor}`;
  document.querySelector(".save-pos-button").style.boxShadow = `0px 0px 10px ${settings.secondaryColor}`;

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